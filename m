Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab1FWKul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:50:41 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:32918 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159Ab1FWKuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:50:40 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: LM95245 driver
Date: Thu, 23 Jun 2011 12:50:37 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: guenter.roeck@ericsson.com,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1308649953-2774-1-git-send-email-alexander.stein@systec-electronic.com> <201106231114.52841.alexander.stein@systec-electronic.com> <20110623113316.6ab5a84e@endymion.delvare>
In-Reply-To: <20110623113316.6ab5a84e@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106231250.38266.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 June 2011 11:33:16 Jean Delvare wrote:
> On Thu, 23 Jun 2011 11:14:52 +0200, Alexander Stein wrote:
> > Well, I noticed that. But I went the way lm95241 does. I'm also unsure
> > which interval to choose, if user specify a unsupported interval. Choose
> > the next small or the next greater one? Maybe you can give me a hint
> > here.
> 
> BTW, is the LM95245 so incompatible that support couldn't be added to
> the lm95241 driver? If both devices are compatible to a reasonable
> degree, a single driver would be preferred.

Well, the register mapping is completly different. Also some configuration 
bits are merged and moved into other registers than in lm95241. I doubt there 
is much more compatibility than i2c transfers and temperature format (despite 
unsigned/unsigned).

Regards,
Alexander
