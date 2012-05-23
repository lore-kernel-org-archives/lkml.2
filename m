Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2EWXqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:46:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2EWXqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:46:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120523093857.GC4085@opensource.wolfsonmicro.com>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
	<1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
	<20120321160913.GF3226@opensource.wolfsonmicro.com>
	<CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
	<20120326154009.GA17506@sirena.org.uk>
	<CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
	<20120523093857.GC4085@opensource.wolfsonmicro.com>
Date: Thu, 24 May 2012 08:46:03 +0900
Message-ID: <CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
Subject: Re: [PATCH v5] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 6:41 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > So, I just said to the SPEAr guys that I really want to see support for
>> > non-cyclic dmaengine added to the helper library rather than open
>> > coding. ?We're seeing lots of platforms moving to dmaengine (as well as
>
>> What is going on this ?
>> Let me know this status.
>
> Nobody seems to be working on it as far as I can tell, I've certainly
> not seen any patches.

If so, could you accept current platform/machine driver ?

thanks in advance.
-- 
ROHM Co., Ltd.
tomoya
