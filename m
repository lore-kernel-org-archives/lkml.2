Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1KYI7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 03:59:10 -0500
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1133 "HELO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752576Ab1KYI7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 03:59:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28909
Message-ID: <4ECF5914.2030602@metafoo.de>
Date: Fri, 25 Nov 2011 10:00:04 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com
Subject: Re: [PATCH 8/8] ASoC: SigmaDSP: Add regmap support
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <1322138908-32127-8-git-send-email-lars@metafoo.de> <201111241230.41331.vapier@gentoo.org>
In-Reply-To: <201111241230.41331.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 06:30 PM, Mike Frysinger wrote:
> On Thursday 24 November 2011 07:48:27 Lars-Peter Clausen wrote:
>> Add support for loading the SigmaDSP firmware using regmap. This allows us
>> to transparently use SPI or I2C as the transport protocol on devices which
>> support them.
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> 
>> For now we keep the old I2C support since we have one user of this which is
>> not straight forward to convert to regmap, due to variable length
>> registers.
> 
> add a Kconfig knob so it's disabled by default except for the old codec ?
> -mike

I don't think it's worth it. The I2C specific code is maybe 15 lines.
