Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1JEHrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:47:16 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:61949 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab1JEHrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:47:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUFAB4KjE6Q/khL/2dsb2JhbABCphiBd4EFgVMBAQEBAxIBZhALGC5XBgErCaEWAZ4HhyMEk2eIXYhp
X-IronPort-AV: E=Sophos;i="4.68,490,1312156800"; 
   d="scan'208";a="57123649"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFCv4 PATCH 0/6]: add poll_requested_events() function
Date: Wed, 5 Oct 2011 09:47:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-4.slh.6-aptosid-amd64; KDE/4.6.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110050947.09488.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 September 2011 09:44:06 Hans Verkuil wrote:
> This is the fourth version of this patch series, incorporating the comments
> from Andrew Morton: I've split up the multiple-assignment line and added a
> comment explaining the purpose of the new function in poll.h.
> 
> It's also rebased to the current staging/for_v3.2 branch of the linux-media
> tree.
> 
> There are no other changes compared to the RFCv3 patches.
> 
> I'd very much like to get an Acked-by (or additional comments) from Al or
> Andrew! This patch series really should go into v3.2 which is getting
> close.
> 
> Normally I would have posted this v4 3 weeks ago, but due to Real Life
> interference in the past few weeks I was unable to. But I'm back, and this
> is currently the highest priority for me.

This is becoming annoying. Andrew, Al, can one of you please Ack this patch or 
review it? We *really* need this enhancement for our v4l drivers. I've been 
asking for an ack (or review) for ages and for the most part I got radio 
silence. Jon Corbet has already reviewed the code in early July (!), so I 
don't see why this is taking so long.

Mauro needs an ack from one of you before he can merge it.

Regards,

	Hans
