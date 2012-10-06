Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2JFUoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:44:07 -0400
Received: from 1wt.eu ([62.212.114.60]:35999 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab2JFUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:44:05 -0400
Date: Sat, 6 Oct 2012 22:43:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5 regression on i915
Message-ID: <20121006204351.GF22618@1wt.eu>
References: <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com> <20121005235845.GE21163@1wt.eu> <20121006072704.GA22465@1wt.eu> <CAPM=9twQb7BUe6cAD-5THBBP-eYAU56__V5UXNn2qfqdFkVwmA@mail.gmail.com> <20121006075956.GF21163@1wt.eu> <051c15$4i14fm@AZSMGA002.ch.intel.com> <20121006084258.GB22618@1wt.eu> <275ffc$6skdfn@fmsmga002.fm.intel.com> <20121006091708.GC22618@1wt.eu> <84c8a8$61252n@orsmga001.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c8a8$61252n@orsmga001.jf.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 05:10:57PM +0100, Chris Wilson wrote:
> So far I have tested -intel-2.6.3 and -intel-2.7.1 with xorg-1.5.3 and
> kernel-3.7 on a 965gm both using the EXA AccelMethod, and both are still
> operational.
> 
> Can you send the complete Xorg.log for the current failure? Thanks,

Yes, I'm sending this to you as well as my dmesg and kernel config off-list
to limit pollution. There's nothing private here so feel free to discuss it
on-list.

Thanks!
Willy

