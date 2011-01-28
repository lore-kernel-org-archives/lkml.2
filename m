Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1A1KwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 05:52:23 -0500
Received: from smtp.nokia.com ([147.243.128.26]:63620 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1A1KwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 05:52:22 -0500
Message-ID: <4D42A033.9030906@maxwell.research.nokia.com>
Date: Fri, 28 Jan 2011 12:53:39 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101123 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de
Subject: Re: [PATCH v8 03/12] media: Entities, pads and links
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the patches!

I've got one comment that I should have made long time ago... Pads are
inputs or outputs... or: are they sinks or sources? I recall that it was
agreed on some occasion that sink and source are much less ambiguous and
they should be used instead.

So we'd have MEDIA_PAD_FL_{SINK,SOURCE}, for example. Currently the
source and documentation is using input/output and source/sink
interchangeably. I think sink and source should be used all the time.

What do you think?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
