Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1BPBTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:19:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1BPBTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:19:07 -0500
Date: Tue, 15 Feb 2011 17:17:54 -0800
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: "Benenati, Chris J" <chris.j.benenati@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: uio: power management of user-space drivers
Message-ID: <20110216011754.GA11181@suse.de>
References: <0635488208022A4F82521A04A4772E15C555EC7E@orsmsx503.amr.corp.intel.com>
 <20110215231236.GE2785@local>
 <0635488208022A4F82521A04A4772E15C555EE4E@orsmsx503.amr.corp.intel.com>
 <20110216001847.GF2785@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216001847.GF2785@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 01:21:04AM +0100, Hans J. Koch wrote:
> Let me guess: suspend/resume functions are supposed to leave your hardware in
> a consistent state and you don't know the state if the suspend() catches you
> in the middle of your userspace processing?
> I remember the Android guys had problems like that and invented some
> "suspend blockers". However, I don't remember what the final answer in that
> discussion was. Greg?

It's all in the kernel today.  See:
	http://lwn.net/Articles/416690/
for all of the details you will ever need.

Hope this helps,

greg k-h
