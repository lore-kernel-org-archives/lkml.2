Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1LMGkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:40:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39728 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab1LMGkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:40:52 -0500
Date: Tue, 13 Dec 2011 14:40:48 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@ti.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] mx27vis-aic32x4: only register when running on the
 right machine
Message-ID: <20111213064047.GD7148@opensource.wolfsonmicro.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
 <1323757911-25217-6-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323757911-25217-6-git-send-email-eric@eukrea.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 07:31:38AM +0100, Eric Bénard wrote:
> without this fix, a kernel compiled with imx_v4_v5_defconfig
> and running on a cpuimx25sd leads to :

I'll apply this but a better fix is to convert the driver to be a normal
platform driver and only register the device on the appropraite boards.
