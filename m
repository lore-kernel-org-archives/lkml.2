Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1ERJc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:32:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46854 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab1ERJcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:32:55 -0400
Message-ID: <4DD39237.5040905@ti.com>
Date: Wed, 18 May 2011 10:32:39 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
CC: Taylor Hutt <thutt@chromium.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] Max98095: Move existing NULL check before
 pointer dereference.
References: <1305680634-10484-1-git-send-email-thutt@chromium.org> <B2150E1E4418E1438554A300EA5040E40DDDA179DA@ITSVLEX06.it.maxim-ic.internal>
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40DDDA179DA@ITSVLEX06.it.maxim-ic.internal>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/11 02:28, Peter Hsiang wrote:
> On Tue, May 17, 2011, Taylor Hutt wrote:
> 
>> Visual inspection shows that max98095_put_eq_enum() and
>> max98095_put_bq_enum() each have a possible NULL deref of 'pdata'.
>>
>> This change moves the NULL check above the use.
>>
>> BUG=none
>> TEST=Visual inspection
> 
> Mark, this patch looks good.
> Thank you Taylor.
> 

Acked-by: Liam Girdwood <lrg@ti.com>
