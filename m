Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2GIGK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:10:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12160 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2GIGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:10:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 08 Jul 2012 23:10:27 -0700
Message-ID: <4FFA7645.4050107@nvidia.com>
Date: Mon, 9 Jul 2012 15:12:21 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>,
        "'Stephen Warren'" <swarren@wwwdotorg.org>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <20120704104840.GJ24458@pengutronix.de> <4FF43692.2040805@nvidia.com> <20120704130056.GC30009@pengutronix.de> <4FF45DDF.9000306@nvidia.com> <20120704152451.GA7333@sirena.org.uk> <4FF4FDC0.8020405@nvidia.com> <20120705062011.GI30009@pengutronix.de> <4FF53368.6090805@nvidia.com> <20120705064742.GL30009@pengutronix.de> <4FF5459F.5090201@nvidia.com> <20120705075714.GA26428@avionic-0098.mockup.avionic-design.de> <4FF54C6C.1060700@nvidia.com> <4FF5BAEE.3020403@wwwdotorg.org> <00ae01cd5d92$70d1f9f0$5275edd0$%han@samsung.com>
In-Reply-To: <00ae01cd5d92$70d1f9f0$5275edd0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 02:19 PM, Jingoo Han wrote:
> I couldn't agree with Stephen Warren more.
> Could you support DT and non-DT case for backwards compatibility?

Both cases are handled in the new version I just sent. I hope all other 
concerns have also been addressed properly. If I forgot something please 
ping me.

Alex.
