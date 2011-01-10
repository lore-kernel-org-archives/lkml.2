Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1AJQFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:05:32 -0500
Received: from kroah.org ([198.145.64.141]:59664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1AJQFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:05:25 -0500
Date: Mon, 10 Jan 2011 08:01:17 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/3] x86: early_quirk check all dev/func in domain 0
Message-ID: <20110110160117.GD5275@kroah.com>
References: <4D2A1152.1040903@kernel.org>
 <4D2A13AA.5070501@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2A13AA.5070501@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 11:59:38AM -0800, Yinghai Lu wrote:
> 
> go with all buses instead of bus0.

Why?  Why limit yourself here?

What's to say I will not have a USB controller on the second domain?  If
you are going to change this, might as well be "correct", right?

Or, if it really doesn't matter, stick with what we have today.

thanks,

greg k-h
