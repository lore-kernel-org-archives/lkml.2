Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1I1TcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:32:00 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:52070 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1I1Tb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:31:59 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4E8375ED.1060209@freescale.com>
Date: Wed, 28 Sep 2011 14:30:53 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 3/6] ASoC: Remove unused "control_data" field of struct
 cs4270_private
References: <1317175218.14102.1.camel@phoenix> <1317175838.14102.4.camel@phoenix>
In-Reply-To: <1317175838.14102.4.camel@phoenix>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> The control_data field is used to initialize the codec's control_data field,
> but since this is also done by the snd-soc-cache core, the redundant
> assignment can be removed and the field can be dropped.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Acked-by: Timur Tabi <timur@freescale.com>

Although Mark, it would have been nice if you had given me a chance to test this
change before applying the patch.

-- 
Timur Tabi
Linux kernel developer at Freescale

