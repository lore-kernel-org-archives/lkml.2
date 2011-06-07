Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1FGIdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:33:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44570 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1FGIdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:33:50 -0400
Message-ID: <4DEDE24D.7070105@ti.com>
Date: Tue, 7 Jun 2011 09:33:17 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] ASoC: AD1836: Fix build error
References: <20110607115505.71c9a330.sfr@canb.auug.org.au> <1307422979-14160-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1307422979-14160-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/11 06:02, Lars-Peter Clausen wrote:
> Commit f97d0c6d5f94 ("ASoC: AD1836: Add input gain control for ADC2") contained
> a typo in the register name, causing a build error. This patch fixes it.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 

Acked-by: Liam Girdwood <lrg@ti.com>
