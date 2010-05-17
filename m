Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0EQQH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:07:58 -0400
Received: from mga07.intel.com ([143.182.124.22]:63974 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752298Ab0EQQH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="278010271"
Date: Mon, 17 May 2010 09:07:55 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/8] x86/mrst: add cpu type detection for Medfield
Message-ID: <20100517090755.000026d4@unknown>
In-Reply-To: <alpine.LFD.2.00.1005170032240.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273873281-17489-3-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005170032240.3368@localhost.localdomain>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>Why are you having mrst_cpu_chip as a caching variable if you expose
>the identify function ? Either you evaluate boot_cpu_data everytime or
>you do it once and expose a function which lets you access the cached
>data. IIRC Alan mentioned that drivers need this info, so the access
>function will need an EXPORT_SYMBOL_GPL to work.
>

I cached value because mrst_cpu_chip is used a few times in mrst.c, I should
fix that to have a unified interface. will also do the EXPORT_SYMBOL_GPL.

thanks.
