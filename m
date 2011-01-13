Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1AMXt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:49:29 -0500
Received: from kroah.org ([198.145.64.141]:59443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab1AMXtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:49:11 -0500
Date: Thu, 13 Jan 2011 15:48:52 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
Message-ID: <20110113234852.GB17904@kroah.com>
References: <4D2BF9F3.5080709@kernel.org>
 <1294731467.17779.352.camel@pasglop>
 <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
 <20110111135655.GA6901@kroah.com>
 <4D2CFEAD.6070206@kernel.org>
 <1294799565.9586.13.camel@pasglop>
 <4D2F7AE9.2000809@kernel.org>
 <20110113224450.GA14918@kroah.com>
 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
 <4D2F84FC.7000804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F84FC.7000804@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 03:04:28PM -0800, Yinghai Lu wrote:
> > 
> > What the hell is the root problem ?
> 
> for patch
> 
> x86: usb handoff in early_quirk
> 
> some systems keep getting
>   APIC calibration not consistent with PM-Timer: 139ms instead of 100ms
>   APIC delta adjusted to PM-Timer: 831249 (1163736)
> 
> USB legacy SMI handler is not disabled at that time.

But is that causing a real problem?  You never answered that question
when I asked it in the past, which makes me think that all of this work
is for no good reason.

thanks,

greg k-h
