Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab1CaOr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:47:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48200 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab1CaOr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:47:57 -0400
Message-ID: <4D94941B.9060103@canonical.com>
Date: Thu, 31 Mar 2011 09:47:55 -0500
From: Manoj <manoj.iyer@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com> <m3sju3z6yc.fsf@pullcord.laptop.org>
In-Reply-To: <m3sju3z6yc.fsf@pullcord.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> How about setting CONFIG_MMC_RICOH_MMC?

In fact that is one of the default config settings, so even if the card 
reader was not present that option is always 'y'

>
> config MMC_RICOH_MMC
>          bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
>          depends on MMC_SDHCI_PCI
>          help
>            This adds a pci quirk to disable Ricoh MMC Controller. This
>            proprietary controller is unnecessary because the SDHCI driver
>            supports MMC cards on the SD controller, but if it is not
>            disabled, it will steal the MMC cards away - rendering them
>            useless. It is safe to select this even if you don't
>            have a Ricoh based card reader.
>
