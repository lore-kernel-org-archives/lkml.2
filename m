Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1BGRAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:00:19 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46568 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123Ab1BGRAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:00:17 -0500
Message-ID: <4D502575.8080501@metafoo.de>
Date: Mon, 07 Feb 2011 18:01:41 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario management
 code.
References: <1297033463-14577-1-git-send-email-lars@metafoo.de> <20110207114255.GB10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207114255.GB10564@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 12:42 PM, Mark Brown wrote:
> On Mon, Feb 07, 2011 at 12:04:17AM +0100, Lars-Peter Clausen wrote:
> 
>> +	snd_soc_dapm_disable_pin(codec, "Audio Out");
>> +	snd_soc_dapm_disable_pin(codec, "GSM Line Out");
>> +	snd_soc_dapm_disable_pin(codec, "GSM Line In");
>> +	snd_soc_dapm_disable_pin(codec, "Headset Mic");
>> +	snd_soc_dapm_disable_pin(codec, "Call Mic");
> 
> This will mean that it's impossible to enable most (if not all) of the
> audio paths in the system which probably isn't what you want.

I've seem to have overlooked to add DAPM_SWITCH_PIN controls for these pins, since it
has been done implicitly in the patch merging the gta01 and gta02 driver.

I'll resend a updated version.

- Lars
