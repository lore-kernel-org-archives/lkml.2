Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1DKUOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:14:36 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:33440 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab1DKUOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:14:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110411192733.GB23059@suse.de>
References: <1302552092-8580-1-git-send-email-andreiw@motorola.com>
	<1302552092-8580-2-git-send-email-andreiw@motorola.com>
	<20110411192733.GB23059@suse.de>
Date: Mon, 11 Apr 2011 15:14:33 -0500
Message-ID: <BANLkTimUjS2cWkSkKm4gZzwQigmHWhN+=A@mail.gmail.com>
Subject: Re: [PATCH] HV SynthHID: Fix compile error.
From: Andrei Warkentin <andreiw@motorola.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, hjanssen@microsoft.com,
        haiyangz@microsoft.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 2:27 PM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Apr 11, 2011 at 03:01:32PM -0500, Andrei Warkentin wrote:
>> Missing include for <asm/delay.h>
>>
>> Signed-off-by: Andrei Warkentin <andreiw@motorola.com>
>> ---
>>  drivers/staging/hv/hv_mouse.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
>> index 50147f8..c5020c0 100644
>> --- a/drivers/staging/hv/hv_mouse.c
>> +++ b/drivers/staging/hv/hv_mouse.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/hiddev.h>
>>  #include <linux/pci.h>
>>  #include <linux/dmi.h>
>> +#include <asm/delay.h>
>
> Never include "<asm/" include files if at all possible.
>

Oops, alright, will do.

> Anyway, this should already be fixed in Linus's tree, right?
>

Sorry no clue, if so, thanks ahead. I was testing something else in
SD/MMC-land and wanted to make sure it compiled cleanly on x86/x64.

A
