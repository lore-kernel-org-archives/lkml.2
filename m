Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1GAJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:32:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:34402 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab1GAJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:32:17 -0400
Message-ID: <4E0D9401.1070300@atmel.com>
Date: Fri, 01 Jul 2011 11:31:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: alsa-devel@alsa-project.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/5] ASoC: wm8731: rework power management
References: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com> <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com> <20110629171148.GB10798@opensource.wolfsonmicro.com> <4E0C80B8.7030006@atmel.com> <20110630152203.GB3249@opensource.wolfsonmicro.com>
In-Reply-To: <20110630152203.GB3249@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/06/2011 17:22, Mark Brown :
> On Thu, Jun 30, 2011 at 03:57:12PM +0200, Nicolas Ferre wrote:
> 
> Please fix your mailer to line wrap within paragraphs.
> 
>> First of all, I experienced issues while not having OSC enabled during
>> suspend/resume cycle. Am I right supposing that, if using oscillator
>> to clock the codec, I have to keep it running during a suspend/resume
>> cycle?
> 
> No, not at all.  What makes you believe that you would you need to do
> that?

Ok, I re-tested and for sure I was totally wrong! So we forget this part
of the patch.
I guess that this belief may come from my first implementation on 2.6.35
where OSC was not part of the DAPM... Sory for the noise.

I repost the "active bit" part real-soon-now.

Thanks for your help, best regards,
-- 
Nicolas Ferre

