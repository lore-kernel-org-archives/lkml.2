Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2IMHR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:17:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab2IMHRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:17:24 -0400
Message-ID: <50518872.9030604@suse.cz>
Date: Thu, 13 Sep 2012 09:17:06 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: David Rientjes <rientjes@google.com>, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] Makefile: Add option CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com> <alpine.DEB.2.00.1209091424580.13346@chino.kir.corp.google.com> <CALF0-+WiEz40qbVbCskuc3TfRcMQUr7wJA20_FfnQmGctG3FXQ@mail.gmail.com>
In-Reply-To: <CALF0-+WiEz40qbVbCskuc3TfRcMQUr7wJA20_FfnQmGctG3FXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.9.2012 02:30, Ezequiel Garcia napsal(a):
> Hi,
> 
> On Sun, Sep 9, 2012 at 6:25 PM, David Rientjes <rientjes@google.com> wrote:
>> On Sat, 8 Sep 2012, Ezequiel Garcia wrote:
>>
>>> diff --git a/Makefile b/Makefile
>>> index ddf5be9..df6045a 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -561,6 +561,10 @@ else
>>>  KBUILD_CFLAGS        += -O2
>>>  endif
>>>
>>> +ifdef CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
>>> +KBUILD_CFLAGS        += -fno-inline-small-functions
>>
>> This isn't the only option that controls automatic inlining of functions,
>> see indirect-inlining, inline-functions, and inline-functions-called-once.
>>
> 
> I'll check about this gcc options and re-send, renamed as:
> CONFIG_DISABLE_CC_AUTOMATIC_INLINING

Please name it CONFIG_CC_<something>

Michal

