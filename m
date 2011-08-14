Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1HNVZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 17:25:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab1HNVZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 17:25:05 -0400
Message-ID: <4E483C88.8090709@redhat.com>
Date: Sun, 14 Aug 2011 23:22:16 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, holt@sgi.com
Subject: Re: [PATCH] Remove name and email address as maintainer for SN2
References: <1313348706-16093-1-git-send-email-Jes.Sorensen@redhat.com> <CA+55aFw4-3o9rX5z3Jtnim5v3K2LhsGyAbXWVG-8iyeCBjGezA@mail.gmail.com>
In-Reply-To: <CA+55aFw4-3o9rX5z3Jtnim5v3K2LhsGyAbXWVG-8iyeCBjGezA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/11 21:22, Linus Torvalds wrote:
> Umm, shouldn't we mark it as unmaintained in this case?
> 
> Or do we have someone who has one of those and is willing to do the
> (not very much) to make sure it keeps compiling and booting?
> 
>                    Linus

Hi,

We could do that too, I am not quite sure what the status is at SGI
these days. CC'ing Robin Holt who can probably tell us whether they want
to add a name or mark it unmaintained.

Cheers,
Jes


> On Sun, Aug 14, 2011 at 12:05 PM,  <Jes.Sorensen@redhat.com> wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
>> ---
>>  MAINTAINERS |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1d445f5..79080e0 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -5921,7 +5921,6 @@ S:        Supported
>>  F:     drivers/net/smsc9420.*
>>
>>  SN-IA64 (Itanium) SUB-PLATFORM
>> -M:     Jes Sorensen <jes@sgi.com>
>>  L:     linux-altix@sgi.com
>>  L:     linux-ia64@vger.kernel.org
>>  W:     http://www.sgi.com/altix
>> --
>> 1.7.4.4
>>
>>

