Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2AZWXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:23:47 -0500
Received: from tex.lwn.net ([70.33.254.29]:44568 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2AZWXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:23:45 -0500
Date: Thu, 26 Jan 2012 15:23:43 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Andrew Chew <achew@nvidia.com>, Paul Mundt <lethal@linux-sh.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Johannes Obermaier <johannes.obermaier@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] convert drivers/media/* to use
 module_i2c_driver()
Message-ID: <20120126152343.7c5da11c@dt>
In-Reply-To: <1327140645.3928.1.camel@phoenix>
References: <1327140645.3928.1.camel@phoenix>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jan 2012 18:10:45 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> This patch converts the drivers in drivers/media/* to use the
> module_i2_driver() macro which makes the code smaller and a bit simpler.

For ov7670.c (belatedly):

	Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
