Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab0LXMAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:00:52 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46285 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0LXMAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:00:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC/PATCH v7 02/12] media: Media device
Date: Fri, 24 Dec 2010 13:01:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com> <1292844995-7900-3-git-send-email-laurent.pinchart@ideasonboard.com> <20101223033346.GB14692@suse.de>
In-Reply-To: <20101223033346.GB14692@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012241301.05834.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for the review.

On Thursday 23 December 2010 04:33:46 Greg KH wrote:
> On Mon, Dec 20, 2010 at 12:36:25PM +0100, Laurent Pinchart wrote:
> > The media_device structure abstracts functions common to all kind of
> > media devices (v4l2, dvb, alsa, ...). It manages media entities and
> > offers a userspace API to discover and configure the media device
> > internal topology.
> 
> As you create sysfs files, please also create Documentation/ABI/ entries
> for those sysfs files at the same time.

Sorry for having forgotten that. I will fix it.

-- 
Regards,

Laurent Pinchart
