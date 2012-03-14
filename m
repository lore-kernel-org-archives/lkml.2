Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2CNH00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:26:26 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:44219 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab2CNH0X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:26:23 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: sdhci-pci: allow 8-bit bus width for Intel PCH
Date: Wed, 14 Mar 2012 08:26:07 +0100
Message-ID: <2073158.vCQHRDAdga@ws-stein>
User-Agent: KMail/4.7.4 (Linux/3.2.1-gentoo-r2; KDE/4.7.4; x86_64; ; )
In-Reply-To: <CANKRQniUQNJmf=H-pY3Wha4qWGh9OJR9GfdTUhMw_t7ZFSnPzA@mail.gmail.com>
References: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com> <1331659002-13743-3-git-send-email-alexander.stein@systec-electronic.com> <CANKRQniUQNJmf=H-pY3Wha4qWGh9OJR9GfdTUhMw_t7ZFSnPzA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomoya,

Am Mittwoch, 14. März 2012, 10:17:35 schrieb Tomoya MORINAGA:
> Hi Alexander
> 
> As a matter of interest,
> do you mean that current MMC of eg20t on Linux doesn't support 8-bit access?

We have a board with an 8-bit connected eMMC and Linux only used 4-bit wide 
bus access. After some research IMO the device is only matched to the default 
PCI id class
> PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)

AFAICS it's the same issue with the Medfield eMMC where 8-bit bus support is 
added in 0d013bcf5c272faea1f8e7a5ef3cb2e98103d5cb
This also states the default is 4-bit bus width which I saw before.

Regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
