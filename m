Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1HKJPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:15:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:7342 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab1HKJPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:15:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,355,1309762800"; 
   d="scan'208";a="37383673"
Date: Thu, 11 Aug 2011 10:19:05 +0100
From: Alan Cox <alan@linux.intel.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH v2] serial:bfin_uart: Put TX IRQ in individual platform
 resource.
Message-ID: <20110811101905.0ff01437@bob.linux.org.uk>
In-Reply-To: <CAJxxZ0Ob6MddPM17B_yhx47ZCCfxa38g0j+bUD4gTbH_GfFhQQ@mail.gmail.com>
References: <1312256727-13906-1-git-send-email-sonic.adi@gmail.com>
	<CAJxxZ0Ob6MddPM17B_yhx47ZCCfxa38g0j+bUD4gTbH_GfFhQQ@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 16:03:52 +0800
Sonic Zhang <sonic.adi@gmail.com> wrote:

> Hi Alan,
> 
> Any comments?
> 
> Sonic Zhang

Fine by me - doesn't really touch any tty specific code or tty
interfacing code anyway
