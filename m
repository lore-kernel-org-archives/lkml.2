Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2HaVyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:54:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46059 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab2HaVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:54:14 -0400
Message-ID: <50413281.8000004@gmail.com>
Date: Sat, 01 Sep 2012 07:54:09 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: mcgrof@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] scripts/checkincludes.pl: Simplify and shorten argument
 logic
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>  <1346419090-3808-3-git-send-email-cruzjbishop@gmail.com> <1346427736.31659.13.camel@joe2Laptop>
In-Reply-To: <1346427736.31659.13.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/12 01:42, Joe Perches wrote:
> On Fri, 2012-08-31 at 23:18 +1000, Cruz Julian Bishop wrote:
>> This patch allows for much easier implementation of arguments
>> when modifying checkincludes.pl
>>
>> The variable $file is also initially named $arg - I wasn't sure
>> if memory would be a problem (I know it would be in Java/C#) if
>> another $file variable was initialized with the value of $arg,
>> so I just left it.
>>
>> Overall, this still works nicely. There are some more
>> potential simplifications, but I will cover those in another
>> patch if I decide to implement them tonight.
> perl argument processing is normally done via Getopt::Long.
>
> http://perldoc.perl.org/Getopt/Long.html
>
Okay, thank you. I'll go look at that now
