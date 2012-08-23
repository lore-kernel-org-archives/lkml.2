Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2HWUQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:16:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56486 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2HWUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:16:19 -0400
Date: Thu, 23 Aug 2012 13:16:14 -0700
From: Tejun Heo <tj@kernel.org>
To: "Clark, Rob" <rob@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] omapdrm: use alloc_ordered_workqueue() instead of
 UNBOUND w/ max_active = 1
Message-ID: <20120823201614.GF14962@google.com>
References: <20120822234944.GS19212@google.com>
 <CAO8GWqmBakf9gLmFh7q3DWWkAzSiUoa09F2dP8MJ2B5E_66fRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO8GWqmBakf9gLmFh7q3DWWkAzSiUoa09F2dP8MJ2B5E_66fRA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 03:08:59PM -0500, Clark, Rob wrote:
> On Wed, Aug 22, 2012 at 6:49 PM, Tejun Heo <tj@kernel.org> wrote:
> > This is an equivalent conversion and will ease scheduled removal of
> > WQ_NON_REENTRANT.
> >
> > Only compile tested.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> I've tested it
> 
> Signed-off-by: Rob Clark <rob@ti.com>

Can you please route this with other omap patches?

Thanks!

-- 
tejun
