Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0LWDey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 22:34:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab0LWDes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 22:34:48 -0500
Date: Wed, 22 Dec 2010 19:33:46 -0800
From: Greg KH <gregkh@suse.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v7 02/12] media: Media device
Message-ID: <20101223033346.GB14692@suse.de>
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1292844995-7900-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292844995-7900-3-git-send-email-laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 12:36:25PM +0100, Laurent Pinchart wrote:
> The media_device structure abstracts functions common to all kind of
> media devices (v4l2, dvb, alsa, ...). It manages media entities and
> offers a userspace API to discover and configure the media device
> internal topology.

As you create sysfs files, please also create Documentation/ABI/ entries
for those sysfs files at the same time.

thanks,

greg k-h
