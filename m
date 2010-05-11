Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0EKCSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:18:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:32191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0EKCSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,204,1272870000"; 
   d="scan'208";a="275571206"
Date: Tue, 11 May 2010 10:30:44 +0800
From: Feng Tang <feng.tang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
Message-ID: <20100511103044.25fed8e7@feng-i7>
In-Reply-To: <4BE84ED7.5010207@zytor.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273258266.1540.63.camel@Joe-Laptop.home>
	<20100507200208.09b2941d@lxorguk.ukuu.org.uk>
	<1273259187.1540.75.camel@Joe-Laptop.home>
	<4BE47059.8090101@zytor.com>
	<20100510171707.28da6795@feng-i7>
	<4BE84ED7.5010207@zytor.com>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 02:22:15 +0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/10/2010 02:17 AM, Feng Tang wrote:
> > 
> > Thank you all for the comments. please review this follow-on patch.
> > 
> > - Feng
> 
> That doesn't move it to common code, though.  I'd rather see existing
> common style used, then merged (centralized) and *then* the style
> corrected.
> 
> 	-hpa

Hi Peter,

The reason I didn't move it to rtc common code is, this vrtc.c sits in
arch/x86/kernel/ and better not to depend on drivers/rtc, as drivers/rtc
may not be always enabled in kernel configuration.

I also have another general driver for vrtc which will be in drivers/rtc/,
just like general x86 kernel which has a rtc.c in arch/ and a rtc-cmos.c
in drivers/rtc, I will clean my code up and try to move these funcs to a
common code. 

Thanks,
Feng
