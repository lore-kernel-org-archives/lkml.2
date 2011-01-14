Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1ANApz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:45:55 -0500
Received: from kroah.org ([198.145.64.141]:40292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab1ANApt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:45:49 -0500
Date: Thu, 13 Jan 2011 16:44:28 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
Message-ID: <20110114004428.GA26847@kroah.com>
References: <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
 <20110111135655.GA6901@kroah.com>
 <4D2CFEAD.6070206@kernel.org>
 <1294799565.9586.13.camel@pasglop>
 <4D2F7AE9.2000809@kernel.org>
 <20110113224450.GA14918@kroah.com>
 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
 <4D2F84FC.7000804@kernel.org>
 <20110113234852.GB17904@kroah.com>
 <4D2F9948.8000804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F9948.8000804@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 04:31:04PM -0800, Yinghai Lu wrote:
> there are some udelay() in drivers/usb/early/ehci-dbgp.c
> 
> that is for early USB debug port console support.
> 
> We should replace them with early version udelay()

Again, I fail to see why.  They work fine today, right?

You _really_ need to prove what you are trying to do here, with lots of
details and descriptions of what the problem is, as it's getting a bit
annoying...

thanks,

greg k-h
