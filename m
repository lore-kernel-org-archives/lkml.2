Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2IXNMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:12:07 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40861 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2IXNMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:12:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LDOC <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v5] media: v4l2-ctrl: add a helper function to add standard control with driver specific menu
Date: Mon, 24 Sep 2012 15:12:41 +0200
Message-ID: <1896630.ZEAaQ0CUMY@avalon>
User-Agent: KMail/4.9.1 (Linux/3.4.9-gentoo; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1348491221-6068-1-git-send-email-prabhakar.lad@ti.com>
References: <1348491221-6068-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2012 18:23:40 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> Add helper function v4l2_ctrl_new_std_menu_items(), which adds
> a standard menu control, with driver specific menu.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Rob Landley <rob@landley.net>

Thank you for not giving up despite the many change requests you have received 
:-)

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

