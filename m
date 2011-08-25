Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1HYQq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:46:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61891 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1HYQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:46:22 -0400
Date: Thu, 25 Aug 2011 18:45:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 0/2] i.MX3: support multi-size buffers in V4L
In-Reply-To: <1314211292-10414-1-git-send-email-g.liakhovetski@gmx.de>
Message-ID: <Pine.LNX.4.64.1108251838090.17190@axis700.grange>
References: <1314211292-10414-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7jwTzS21fUJDFlI8ZbOvcbgh7x6Glp0YuDJvnoIPO4c
 fx89Tb9v5OzJ0a6mqnuOE203o360hWzQ6n2wAjUUkiAbbgyi2U
 HD/GOEwteB/RWAWhNtAg7iiPsXkBoqbLkgOs9vLVqMhhvTcewZ
 5ocOkm2ScBaj+7Kk+QSdoXn9tCKnBVbdrNQ5lqsdNWXt10AjcN
 pPEL8c7NAT1XawHHCl+HL7DVi0dI8MmfnK39qjgmwg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supporting new V4L2 ioctl()s in the mx3_camera driver also requires an 
extension for the ipu-idmac dmaengine driver. The original thread, adding 
the ioctl()s can be found here:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/37143

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
