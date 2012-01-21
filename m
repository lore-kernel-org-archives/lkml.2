Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2AUMc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 07:32:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41555 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2AUMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 07:32:24 -0500
Message-ID: <4F1AB053.109@gmail.com>
Date: Sat, 21 Jan 2012 13:32:19 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH] [media] convert drivers/media/* to use module_i2c_driver()
References: <1327140645.3928.1.camel@phoenix>
In-Reply-To: <1327140645.3928.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2012 11:10 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/media/* to use the
> module_i2_driver() macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin<axel.lin@gmail.com>

For s5k6aa, noon010pc30, sr030pc30, m5mols modules,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester
