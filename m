Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1JSMHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:07:42 -0400
Received: from smtp-out-086.synserver.de ([212.40.185.86]:1136 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754474Ab1JSMHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:07:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22945
Message-ID: <4E9EBD98.9090705@metafoo.de>
Date: Wed, 19 Oct 2011 14:07:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111005 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Liam Girdwood <lrg@ti.com>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: ssm2602: Use snd_soc_update_bits for read-modify-write
References: <1319004451.16275.1.camel@phoenix> <1319012280.4133.0.camel@odin>
In-Reply-To: <1319012280.4133.0.camel@odin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 10:18 AM, Liam Girdwood wrote:
> On Wed, 2011-10-19 at 14:07 +0800, Axel Lin wrote:
>> Use snd_soc_update_bits for read-modify-write register access instead of
>> open-coding it using snd_soc_read and snd_soc_write
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Liam Girdwood <lrg@ti.com>
> 

Acked-by: Lars-Peter Clausen <lars@metafoo.de>
