Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab2HaVzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:55:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2HaVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:55:49 -0400
Message-ID: <504132E1.1080508@gmail.com>
Date: Sat, 01 Sep 2012 07:55:45 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: mcgrof@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] scripts/checkpatch.pl: A small step for Linux...
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com> <alpine.LNX.2.00.1208312008210.14761@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1208312008210.14761@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/12 04:09, Jesper Juhl wrote:
> On Fri, 31 Aug 2012, Cruz Julian Bishop wrote:
>
>> ...and a big step for learning more Perl.
>>
>> Hi!
>>
>> This patch set started off as an experiment, but as I continued, I
>> realised that I should submit this and see if it's suitable for merging
>> into Linux.
>>
>> To start off with, here's some patches for checkincludes.pl
>>
>> This set was created for the following purposes:
>>
>>     1: Making it slightly easier to read
>>     2: Making it easier to extend and add new arguments
>>     3: Changing the usage output to look more "correct"
>>     4: Introducing a 'quiet' mode like checkpatch.pl, and printing
>>         messages for files without duplicated includes by default
>>        
>> Sorry if I did anything wrong - It's my first time really
>> experimenting with Perl. 
>>
>> Thanks in advance.
>>
>> ~Cruz
>>
>> Cruz Julian Bishop (4):
>>   scripts/checkincludes.pl: Print usage with heredoc
>>   scripts/checkincludes.pl: Simplify and shorten argument logic
>>   scripts/checkincludes.pl: Fix a bug introduced in the last commit
>>   scripts/checkincludes.pl: Introduce 'quiet' mode
>>
>>  scripts/checkincludes.pl |  113 ++++++++++++++++++++++++++--------------------
>>  1 file changed, 65 insertions(+), 48 deletions(-)
>>
>>
> Minor detail. Your patches are for "scripts/checkincludes.pl" but the 
> subject says "scripts/checkpatch.pl"... You may want to get it straight 
> what you are patching and let the subject reflect reality :-)
>
Yeah, I ended up writing the cover letter at 11:30 at night without any
coffee :-)

I'll look at a link that Joe Perches sent me then resubmit this

Thanks.

~Cruz
