Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab1FWJdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:33:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48377 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942Ab1FWJdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:33:24 -0400
Date: Thu, 23 Jun 2011 11:33:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: guenter.roeck@ericsson.com,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: LM95245 driver
Message-ID: <20110623113316.6ab5a84e@endymion.delvare>
In-Reply-To: <201106231114.52841.alexander.stein@systec-electronic.com>
References: <1308649953-2774-1-git-send-email-alexander.stein@systec-electronic.com>
	<1308770149.8271.600.camel@groeck-laptop>
	<201106231114.52841.alexander.stein@systec-electronic.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 11:14:52 +0200, Alexander Stein wrote:
> Well, I noticed that. But I went the way lm95241 does. I'm also unsure which 
> interval to choose, if user specify a unsupported interval. Choose the next 
> small or the next greater one? Maybe you can give me a hint here.

BTW, is the LM95245 so incompatible that support couldn't be added to
the lm95241 driver? If both devices are compatible to a reasonable
degree, a single driver would be preferred.

-- 
Jean Delvare
