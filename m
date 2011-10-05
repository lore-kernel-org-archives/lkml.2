Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab1JEVCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:02:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57736 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1JEVCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:02:01 -0400
Date: Wed, 5 Oct 2011 14:01:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: viro@zeniv.linux.org.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv4 PATCH 0/6]: add poll_requested_events() function
Message-Id: <20111005140156.70ed0329.akpm@linux-foundation.org>
In-Reply-To: <201110050947.09488.hverkuil@xs4all.nl>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
	<201110050947.09488.hverkuil@xs4all.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011 09:47:09 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Thursday 29 September 2011 09:44:06 Hans Verkuil wrote:
> > This is the fourth version of this patch series, incorporating the comments
> > from Andrew Morton: I've split up the multiple-assignment line and added a
> > comment explaining the purpose of the new function in poll.h.
> > 
> > It's also rebased to the current staging/for_v3.2 branch of the linux-media
> > tree.
> > 
> > There are no other changes compared to the RFCv3 patches.
> > 
> > I'd very much like to get an Acked-by (or additional comments) from Al or
> > Andrew! This patch series really should go into v3.2 which is getting
> > close.
> > 
> > Normally I would have posted this v4 3 weeks ago, but due to Real Life
> > interference in the past few weeks I was unable to. But I'm back, and this
> > is currently the highest priority for me.
> 
> This is becoming annoying. Andrew, Al, can one of you please Ack this patch or 
> review it? We *really* need this enhancement for our v4l drivers. I've been 
> asking for an ack (or review) for ages and for the most part I got radio 
> silence. Jon Corbet has already reviewed the code in early July (!), so I 
> don't see why this is taking so long.
> 
> Mauro needs an ack from one of you before he can merge it.
> 

It looks OK to me, but obviously it would be better if Al were to go
through it also.  If he doesn't then there isn't a lot we can do about
it - I suggest that you proceed with the plan to merge it into -rc1.
