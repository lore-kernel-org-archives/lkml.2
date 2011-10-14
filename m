Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab1JNUGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:06:37 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:60489 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab1JNUGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:06:35 -0400
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 16:06:35 EDT
Message-ID: <4E989115.5000304@mentor.com>
Date: Fri, 14 Oct 2011 23:44:21 +0400
From: Vladimir Barinov <Vladimir_Barinov@mentor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        Liam Girdwood <lrg@ti.com>, <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 2/3] ASoC: tlv320aic3x: Convert codec->hw_read to snd_soc_read
References: <1318556120.6379.1.camel@phoenix> <1318556220.6379.3.camel@phoenix> <20111014193553.GH2931@opensource.wolfsonmicro.com>
In-Reply-To: <20111014193553.GH2931@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2011 19:33:28.0405 (UTC) FILETIME=[26074050:01CC8AA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Fri, Oct 14, 2011 at 09:37:00AM +0800, Axel Lin wrote:
>   
>> codec->hw_read is broken now, let's covert to snd_soc_read.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>     
>
> Applied, thanks.  You really should CC the TI guys on this driver,
> especially Jarkko, as they have been doing most of the work on it.
> Vladimir hasn't been very active since the initial contribution.
>   
Yes, please, since I have no actual h/w and can't maintain the codec 
driver anymore.
Also the layer specific changes (not h/w related) should be reviewed by 
ASoC guru and not me.

Regards,
Vladimir

