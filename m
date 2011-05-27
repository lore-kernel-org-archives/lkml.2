Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab1E0IsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:48:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1E0IsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:48:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Date: Fri, 27 May 2011 10:48:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org> <201105201223.00427.arnd@arndb.de> <20110527082916.GB30146@S2100-06.ap.freescale.net>
In-Reply-To: <20110527082916.GB30146@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271048.00692.arnd@arndb.de>
X-Provags-ID: V02:K0:7Q7IglUdHptq08/mCD4v5KCfw6XQjMpbVE/wf50dtu0
 ClAbqxNXNl+cUoTW/g3zjaFfnLl/eYVz36aHDCkUyluq6MY93f
 ub/qFH0A612ef8dDO9aLiR7OqPoSMyn3ZZJw6b1ue+jZXZarXe
 6eNTHz+fEasxSja9B9i5xksl1vF5HMhI4Z1v+C5PzrJFPmSXT6
 3pHibmZrYq77kNaSQ9lRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 May 2011, Shawn Guo wrote:

> > I know it's tempting to use macros for these, but I think it obscures
> > the code a lot, especially when you use them to concatenate identifier
> > names. Why not just do:
> > 
> >       struct platform_device *gpios;
> >       gpios = platform_device_register_simple(mxs_host_bus, "mxs-gpio-master", 0, NULL, 0);
> > 
> platform_device_register_simple does not have parameter for 'parent',
> and it sets 'parent' NULL anyway.
> 

Oops, my mistake. just use platform_device_register_resndata directly then.

	Arnd
