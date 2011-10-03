Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1JCJwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:52:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57567 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1JCJv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:51:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/30] video/omap: fix build dependencies
Date: Mon, 03 Oct 2011 11:51:49 +0200
Message-ID: <6628015.ZCJR4R4V8E@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317625175.2026.8.camel@deskari>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-4-git-send-email-arnd@arndb.de> <1317625175.2026.8.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Cla3iaS00T38nxQyPvwPioJ4uWF6nG8uYSvD0mD4tjo
 mo3yBbTbQScxVHOxOpKgBziG7T4OZuYX3ESS8yYSZi9xGv5bS3
 HjuvAjcN7RQwIuXW9YV8o8LzJMEg0wkWjDM1nquSBVJXcsCnBC
 ND/erhNBZRhIkKWZBOdzgHHLUu3U8WFco7N207VrumUFcjfN4z
 e1OJXj+YXIaZXydzNfckUAEud93nvTtCtK6bGzU2r25VdEXh37
 N50YDrhbkD9mrzbzT/E1IwwHDd9ztjGUac53bVQqWcgxQh8LEE
 C0qzGyhIeh/FfZw9UMcJrugGYmlfbnwzXye1vobJG/M902ywro
 ExGHRGwCo1Q76Z+GDTBY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 09:59:35 Tomi Valkeinen wrote:
> On Sun, 2011-10-02 at 16:45 +0200, Arnd Bergmann wrote:
> > Four of the LCD panel drivers depend on the backlight class,
> > so add the dependency in Kconfig.
> > Selecting the BACKLIGHT_CLASS_DEVICE symbol does not generally
> > work since it has other dependencies.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> 
> This looks ok to me. If it's fine to you, I'll queue this patch in my
> DSS tree to prevent possible conflicts.

Yes, that's good.

Thanks,

	Arnd
