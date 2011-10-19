Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1JSIBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:01:51 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46010 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab1JSIBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E9D9F88.109@metafoo.de>
References: <1318890308.15935.0.camel@phoenix>
	<4E9D9F88.109@metafoo.de>
Date: Wed, 19 Oct 2011 09:01:49 +0100
Message-ID: <CABS+qY1puXbMmgb8RMgoQydp7fKX4KJ9Z6GEZ40--X_fDBCxZQ@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: ad193x: Use snd_soc_update_bits for read-modify-write
From: "Girdwood, Liam" <lrg@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 October 2011 16:47, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 10/18/2011 12:25 AM, Axel Lin wrote:
>> Use snd_soc_update_bits for read-modify-write register access instead of
>> open-coding it using snd_soc_read and snd_soc_write
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
>

Acked-by: Liam Girdwood <lrg@ti.com>
