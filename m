Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0KYPfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:35:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53359 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752112Ab0KYPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:35:48 -0500
Date: Thu, 25 Nov 2010 15:35:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] [alsa-devel] media: Entities, pads and
 links
Message-ID: <20101125153546.GI22298@rakim.wolfsonmicro.main>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <4CEE2E7D.6060608@ladisch.de>
 <20101125134135.GB24208@opensource.wolfsonmicro.com>
 <201011251629.54575.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011251629.54575.laurent.pinchart@ideasonboard.com>
X-Cookie: Beam me up, Scotty!  It ate my phaser!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 04:29:53PM +0100, Laurent Pinchart wrote:

> It depends on how you define nodes. I can certainly imagine a graph with 100 
> controls, but maybe several controls can be part of the same node ? On the 
> video side we've decided to split entities depending on the possible data 
> paths configurations. As I'm not a fluent ascii-art speaker, please have a 
> look at pages 4 and 5 of http://www.ideasonboard.org/media/20101103-lpc-
> media.pdf

Please take a look at:

	http://www.wolfsonmicro.com/products/WM8994

for an example of a modern smartphone CODEC.  This has in the ballpark
of 75-100 nodes (I've not counted exactly) represented in the routing
graph in the driver today.  This does not include any audio routing
available in other components such as the CPU.
