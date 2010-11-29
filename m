Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab0K2OyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:54:04 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:36915
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0K2OyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:54:02 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz1432N98dN148cMzz1202hzz8275bhz2dh2a8h691h637h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CF3BE7C.2000006@freescale.com>
Date: Mon, 29 Nov 2010 08:53:48 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 1/2] ASoC: Add missing dev_set_drvdata in mpc8610_hpcd_probe
References: <1291013698.19113.1.camel@mola>
In-Reply-To: <1291013698.19113.1.camel@mola>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2010 14:55:07.0117 (UTC) FILETIME=[6982B1D0:01CB8FD5]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> Otherwise, calling dev_get_drvdata in mpc8610_hpcd_remove returns NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Both patches:

Acked-by: Timur Tabi <timur@freescale.com>

Thanks for catching this.

-- 
Timur Tabi
Linux kernel developer at Freescale

