Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1K1TCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:02:14 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62393 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370Ab1K1TCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:02:13 -0500
Message-ID: <4ED3DA92.6050704@metafoo.de>
Date: Mon, 28 Nov 2011 20:01:38 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, drivers@analog.com,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/7] ASoC: AD193X: Make enum items const char * const
References: <1322497692-27868-1-git-send-email-lars@metafoo.de> <1322497692-27868-3-git-send-email-lars@metafoo.de> <20111128185345.GA1586@opensource.wolfsonmicro.com>
In-Reply-To: <20111128185345.GA1586@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 07:53 PM, Mark Brown wrote:
> On Mon, Nov 28, 2011 at 05:28:08PM +0100, Lars-Peter Clausen wrote:
> 
>> -static const char *ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};
>> +static const char * const ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};
> 
> Ideally this would be converted to a switch and the driver would
> automatically select the rate based on the current sample rate.

Ideally yes, but I'm not sure if this couldn't break some existing setup if it
expects to find that control.

- Lars
