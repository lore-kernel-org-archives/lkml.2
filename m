Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1CYQaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:30:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43001 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab1CYQaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=t82P0z4NIyI2dq7yNzIlnFA0RPpaO084rMGpa+B+EBEAzMx9mqYyyXOYTwQQK7qD74
         VUuw6ZekOvv6djhX/6HCmKS9lYFToyEqY326DuiWvNe5w+7TRT/Roi6N0T3Llm7RWkk4
         l0opW0RdApRziTmiyZYCXWqR5FVCF7QXjQ0FE=
MIME-Version: 1.0
In-Reply-To: <20110325154118.GN21838@one.firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org>
	<1300914043-2297-3-git-send-email-abogani@kernel.org>
	<m27hbov7hq.fsf@firstfloor.org>
	<8739mblr2n.fsf@rustcorp.com.au>
	<20110325154118.GN21838@one.firstfloor.org>
Date: Fri, 25 Mar 2011 17:30:11 +0100
X-Google-Sender-Auth: 5f3buj4-Dkzc8IDKZs-3vxHunnA
Message-ID: <AANLkTinW4GA094Yz94Y0qTEJvjOmRe4_C+5yc7_VcKM3@mail.gmail.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for
 locate the symbols
From: Alessio Igor Bogani <abogani@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Ian Lance Taylor <ian@airs.com>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Kleen,

2011/3/25 Andi Kleen <andi@firstfloor.org>:
[...]
>> > Patch looks good to me. SORT is a nice trick, too bad it won't
>> > work for the main kernel.
>>
>> Why not?
>
> Because kallsyms is supposed to be in address order, not name order.

What should that break exactly?
Thanks you very much!

Ciao,
Alessio
