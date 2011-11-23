Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1KWRj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:39:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61526 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1KWRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:39:53 -0500
Date: Wed, 23 Nov 2011 09:39:47 -0800
From: Tejun Heo <tj@kernel.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, rjw@sisk.pl,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] dmatest: don't use set_freezable_with_signal()
Message-ID: <20111123173947.GD29639@google.com>
References: <20111121184316.GH15314@google.com>
 <CABE8wwu-ZH47tFkaEmYfWtXzgeR9KmEWXbtXD5FEQc3R9tV7aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABE8wwu-ZH47tFkaEmYfWtXzgeR9KmEWXbtXD5FEQc3R9tV7aQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 22, 2011 at 11:48:07PM -0800, Williams, Dan J wrote:
> > Guennadi, Dan, how does this look?  If it's okay, do you guys mind
> > routing this through pm tree?  I have some patches stacked on top
> > removal of freezable_with_signal and it would be much easier to route
> > these together.
> >
> > Thank you.
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> (for the revised commit a75ca055 on
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer)

Awesome, will add Acked-by and push it to Rafael.

Thank you.

-- 
tejun
