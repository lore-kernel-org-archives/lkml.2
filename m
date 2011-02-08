Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1BHNqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:46:46 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:57562 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1BHNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:46:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v8 03/12] media: Entities, pads and links
Date: Tue, 8 Feb 2011 14:46:43 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.36-gentoo-r3; KDE/4.6.0; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com> <4D42A033.9030906@maxwell.research.nokia.com>
In-Reply-To: <4D42A033.9030906@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081446.43643.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On Friday 28 January 2011 11:53:39 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patches!
> 
> I've got one comment that I should have made long time ago... Pads are
> inputs or outputs... or: are they sinks or sources? I recall that it was
> agreed on some occasion that sink and source are much less ambiguous and
> they should be used instead.
> 
> So we'd have MEDIA_PAD_FL_{SINK,SOURCE}, for example. Currently the
> source and documentation is using input/output and source/sink
> interchangeably. I think sink and source should be used all the time.
> 
> What do you think?

I think it makes sense. Hans ?

-- 
Regards,

Laurent Pinchart
