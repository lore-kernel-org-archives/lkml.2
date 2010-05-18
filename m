Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0ERW5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:57:40 -0400
Received: from mga07.intel.com ([143.182.124.22]:32236 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751894Ab0ERW5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="278693187"
Date: Tue, 18 May 2010 15:57:36 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 2/2] v4 x86/mrst: add more timer config options
Message-ID: <20100518155736.00007d03@unknown>
In-Reply-To: <alpine.LFD.2.00.1005182240480.3368@localhost.localdomain>
References: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1274184166-17242-3-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005182240480.3368@localhost.localdomain>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>  
>> +/**
>
>  Do not use kerneldoc /** opener from plain comments. Randy
>  complained about that yesterday already
>
I missed randy's comment at the end. sorry. I admit I did not know kernel-doc
before that.

		if (mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL) {
>
>  Why do you want to pin that on PENWELL and not on ARAT ? If you
>  check ARAT, you have coverd all next gen cpus as well.

I did try ARAT first but ARAT is not available at this point. the add-on cpu
features are set later.

Thanks,

Jacob
