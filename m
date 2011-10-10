Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1JJHim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:38:42 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:33487 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1JJHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:38:40 -0400
Message-ID: <4E92A0F4.7060107@free-electrons.com>
Date: Mon, 10 Oct 2011 09:38:28 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
CC: Michael Opdenacker <michael.opdenacker@linaro.org>, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] omap: sound: fix "ambiguous else" warning
References: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org> <1318223228-15671-2-git-send-email-michael.opdenacker@linaro.org> <4E9296A2.50003@bitmer.com>
In-Reply-To: <4E9296A2.50003@bitmer.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 08:54 AM, Jarkko Nikula wrote:
> Hi
>
> On 10/10/2011 08:07 AM, Michael Opdenacker wrote:
>> This patch applies against Tony Lindgren's linux-omap tree
>> It fixes "ambiguous else" warnings at compile time.
>>
>> Signed-off-by: Michael Opdenacker<michael.opdenacker@linaro.org>
>> ---
>>   sound/soc/omap/omap-mcbsp.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
> This is already fixed in ASoC tree by following commit
>
> commit 141947e6ceb8f82fe8382b26f093bb379af9af15
> Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Date:   Mon Sep 26 10:56:42 2011 +0300
>
>     ASoC: omap-mcbsp: Fix compile time warning about ambiguous ‘else’
Perfect, thanks. I'll keep an eye on the ASoC tree next time.

Michael.


-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+ 33 621 604 642

