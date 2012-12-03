Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab2LCL5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:57:17 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40310 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab2LCL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:57:15 -0500
Date: Mon, 3 Dec 2012 12:57:06 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Felipe Balbi <balbi@ti.com>
Cc: Behan Webster <behanw@converseincode.com>, davem@davemloft.net,
        linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Message-ID: <20121203115706.GA4760@breakpoint.cc>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
 <1351631937-21455-3-git-send-email-behanw@converseincode.com>
 <20121031132838.GQ10998@arwen.pp.htv.fi>
 <509144C0.8000601@converseincode.com>
 <20121101072116.GA32013@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101072116.GA32013@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 09:21:16AM +0200, Felipe Balbi wrote:
> then we can merge to net tree and handle the conflicts when merging to
> Linus, that'd be fine by me as long as people know how to solve the
> conflict properly ;-)

Felipe please drop this patch. I don't like this VLAIS patch and its
macro magic. I support the goal of compiling the kernel with clang but I
don't think that this is appropriate. Davem has also his problems with
the netfilter part so I am no the only one.
*I* think the gadget part of the kernel is something most people won't
use so it won't show up.
Anyway, please drop this completely I try to think of something sane.

Sebastian
