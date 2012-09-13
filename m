Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2IMAa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:30:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2IMAa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209091424580.13346@chino.kir.corp.google.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
	<alpine.DEB.2.00.1209091424580.13346@chino.kir.corp.google.com>
Date: Wed, 12 Sep 2012 21:30:55 -0300
Message-ID: <CALF0-+WiEz40qbVbCskuc3TfRcMQUr7wJA20_FfnQmGctG3FXQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] Makefile: Add option CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: David Rientjes <rientjes@google.com>, sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Sep 9, 2012 at 6:25 PM, David Rientjes <rientjes@google.com> wrote:
> On Sat, 8 Sep 2012, Ezequiel Garcia wrote:
>
>> diff --git a/Makefile b/Makefile
>> index ddf5be9..df6045a 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -561,6 +561,10 @@ else
>>  KBUILD_CFLAGS        += -O2
>>  endif
>>
>> +ifdef CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
>> +KBUILD_CFLAGS        += -fno-inline-small-functions
>
> This isn't the only option that controls automatic inlining of functions,
> see indirect-inlining, inline-functions, and inline-functions-called-once.
>

I'll check about this gcc options and re-send, renamed as:
CONFIG_DISABLE_CC_AUTOMATIC_INLINING

Thanks for both your feedback,
Ezequiel.
