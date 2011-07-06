Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1GFX72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:59:28 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49115 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635Ab1GFX71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:59:27 -0400
X-Sasl-enc: R2hD9hmSA9k1PMYGDiO7LtFGEIyPC5Hs4flOx8OEiMyt 1309996765
Date: Wed, 6 Jul 2011 16:27:20 -0700
From: Greg KH <greg@kroah.com>
To: Bryan Freed <bfreed@chromium.org>
Cc: linux-kernel@vger.kernel.org, jic23@cam.ac.uk, gregkh@suse.de,
        rklein@nvidia.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] staging:iio: Reorder channel type strings to match
 the iio.h enums.
Message-ID: <20110706232720.GA28400@kroah.com>
References: <1309978586-10092-1-git-send-email-bfreed@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309978586-10092-1-git-send-email-bfreed@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 11:56:24AM -0700, Bryan Freed wrote:
> This makes comparison between the iio_chan_type_name_spec_shared strings
> and the iio_chan_type enums easier.

This, and patch 2/3, don't apply at all to my tree, what did you make
them against?

greg k-h
