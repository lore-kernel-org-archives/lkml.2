Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1JBSDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:03:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1JBSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:02:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 10/30] ARM: omap/iommu: always provide iommu debug code
Date: Sun, 02 Oct 2011 20:01:30 +0200
Message-ID: <1377050.B9gMvYWCVB@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAK=WgbY-1VU5tJNxaJmP+8xqxV+XHjFeV=hjmxpZNuQJdKg=BQ@mail.gmail.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-11-git-send-email-arnd@arndb.de> <CAK=WgbY-1VU5tJNxaJmP+8xqxV+XHjFeV=hjmxpZNuQJdKg=BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QbXLoyOG4SeKXGrklCFaftYvTPIM6zNR3cucJejObeb
 tvoii2CeXdNypmaIiZItrzK2tGcDQrwV9L1kgrg3W3s/91nvmb
 yAxONinQm53Z2d86fkopnNq1wNQMjKpZKva8H6s6U0ZBSGZeqC
 isOTUju5PZeLXm8EgWU1PwgHXLdApDxMkR12c3Z4lBNwi4fcYB
 pk44KB4dXD0JzifOXQEKb9MmAegkcBz+s9ZBikYSJqcAXUcPfj
 2PL+oWjLuJq1mWbUR86ujM0bHSpRyrzMXfNQxOY21BfXOqF+vN
 eRw+f0cGBZ9po15KCZf+CpstUH338X1bS5dHEh7yLG+JHN00d3
 wlacMC27D/Ug3rA54ugY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 18:34:52 Ohad Ben-Cohen wrote:
> 
> The driver has moved to drivers/iommu/ and changed a bit, but this
> patch is still relevant.
> 
> The merge conflict will be trivial to resolve, but if you prefer, we
> can prevent it by taking this patch via the iommu tree.

Yes, please take it into the iommu tree, so I don't have to track
the conflict.

Thanks,

	Arnd
