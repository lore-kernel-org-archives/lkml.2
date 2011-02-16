Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1BPSPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 13:15:33 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:57713 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1BPSP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 13:15:29 -0500
Date: Wed, 16 Feb 2011 19:15:26 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "Benenati, Chris J" <chris.j.benenati@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: uio: power management of user-space drivers
Message-ID: <20110216181526.GA2800@local>
References: <0635488208022A4F82521A04A4772E15C555EC7E@orsmsx503.amr.corp.intel.com>
 <20110215231236.GE2785@local>
 <0635488208022A4F82521A04A4772E15C555EE4E@orsmsx503.amr.corp.intel.com>
 <20110216001847.GF2785@local>
 <20110216011754.GA11181@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216011754.GA11181@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:17:54PM -0800, Greg KH wrote:
> On Wed, Feb 16, 2011 at 01:21:04AM +0100, Hans J. Koch wrote:
> > Let me guess: suspend/resume functions are supposed to leave your hardware in
> > a consistent state and you don't know the state if the suspend() catches you
> > in the middle of your userspace processing?
> > I remember the Android guys had problems like that and invented some
> > "suspend blockers". However, I don't remember what the final answer in that
> > discussion was. Greg?
> 
> It's all in the kernel today.  See:
> 	http://lwn.net/Articles/416690/
> for all of the details you will ever need.

Interesting. After reading that, I've got the impression that this could be
used by UIO drivers and maybe solve Chris' problem. Or did I miss something?

Thanks,
Hans
