Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0FKGer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:34:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49808 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0FKGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EGdHNzvVGTFBmo6epOazEMEEU1ebL6PDNEBQfu28cLsgxxmW4F2kB7+R0JXrkqMRVN
         lQnY3MNlB2+ALqQafMjGRhOM5g7L5cGancXpHojbPAMBC9O9OZJzFdtjN+m5WI69mzbA
         JdVAdPkiLwUsx+BBBGeXqkNoNrtDcBqE+D5hE=
Message-ID: <4C11D90C.9010005@gmail.com>
Date: Thu, 10 Jun 2010 23:34:52 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: warning from gcc version 4.6.0 20100416
References: <4C11A598.8090504@gmail.com> <20100611061610.GA6864@basil.fritz.box>
In-Reply-To: <20100611061610.GA6864@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 11:16 PM, Andi Kleen wrote:
> On Thu, Jun 10, 2010 at 07:55:20PM -0700, Justin P. Mattock wrote:
>> o.k. andi,
>>
>> here is the rest of the warnings that
>> I see when compiling the kernel
>>
>> I can try and create some patches for
>> this(hopefully!!)
>
> The key point is that you need to review
> each warning if it's a real bug or just a false
> positive.
>
> This is not always trivial, I got at least one
> wrong in the earlier series (shut up one real bug)
>
> -Andi
>

Some are trivial, but then
some require changes i.g.
the variable is removed but the function
requires more than two variables kind of error..
leaving me in a whirlwind with what to put there..

I'll go and try for the easy ones,
first, then(try) and tackle hard ones.

Justin P. Mattock
