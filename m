Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2DWSci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:32:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2DWScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:32:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/3] ARM: tegra: Add AHB driver
Date: Mon, 23 Apr 2012 18:32:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com> <201204231233.09423.arnd@arndb.de> <4F9598AD.2030308@wwwdotorg.org>
In-Reply-To: <4F9598AD.2030308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204231832.16268.arnd@arndb.de>
X-Provags-ID: V02:K0:9XD1Y/vl1ukHt09TaFTGRcKgwAFZygU1QMpcWoSfrlV
 10mP10MImeBI3aGffoxXQ0WyEK+gT1icXpKkncdNHLgqYTIh+N
 gXfjX+MG1Sk7//TQr2pP291SwsMrZkE0vRFYMYqRwilCWplmgV
 ZESVt8rGc0HGaRqp84z1IplOGKmghHwS+dRwiWyHrqZrTGjUFr
 Te9ZZqAtDiVzsa9LNF7cE+i8JtGPpZmXymAU19tHGXbpwQBBmw
 yRcCvveb3NpEQvMBm4S2LKSRqIbvmdKpsXbNuX6ihO2YkUVhGx
 2NG/5BK7vdidxyHIAeYbLySx6cChB4EzeN7gU/N1d/JTlAHxds
 TTZNBmMGFdRLURtJD6e4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2012, Stephen Warren wrote:
> I don't know whether it has to be early, but if this driver isn't going
> to be instantiated from device tree, I'd prefer it to be initialized by
> an explicit function call from the boards or common code rather than an
> initcall. It seems a lot easier to keep track of all the initialization
> by doing it explicitly. That said, it's quite possible this API couuld
> be called from say init_machine instead of init_early though.

Having it called from init_machine sounds ok, as long as it still
scans the device tree for the addresses rather than hardcoding.

	Arnd
