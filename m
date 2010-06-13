Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0FMM4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 08:56:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53446 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0FMM4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 08:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q/uzTdnlfmhwRnU7b14AO2nVNcfVXQ89tdeXIk1mq9CVoOzcu70Jm7aBsdnmTinLtN
         AjpGBh23Nh1VNCT41dV07qpeu3s4bjCMAe+4+a3X1h9sNPPfCDrhaOkh/BBKTsEJ+FfI
         8U57QRxMphp8v56+RI0ar93arGerxwcRNzNuw=
MIME-Version: 1.0
In-Reply-To: <4C149194.2060507@redhat.com>
References: <AANLkTinUhfVvK7UOC6FiW9nG6xXRwCpDlAaedbSwFo7d@mail.gmail.com>
	<4C149194.2060507@redhat.com>
Date: Sun, 13 Jun 2010 14:56:36 +0200
X-Google-Sender-Auth: SR-8Pcr6BhUfZK8tPARHubV9jVY
Message-ID: <AANLkTilXDyHpBA5xZGTBQwl3s7A0zSYcRNKuykBhOOyY@mail.gmail.com>
Subject: Re: [PATCH] These are my first patches to the kernel
From: "K.de Jong" <k.dejong@undifined.nl>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/13 Avi Kivity <avi@redhat.com>:
> On 06/12/2010 03:17 PM, K.de Jong wrote:
>>
>>  From 6b9ac8708d856a425a9aaa598acdea3d89485bde Mon Sep 17 00:00:00 2001
>> From: UndiFineD<k.dejong@undifined.nl>
>> Date: Sat, 12 Jun 2010 00:24:28 +0200
>> Subject: [PATCH] These are my first patches to the kernel
>> Janitor patches to kvm
>> Linus2.6: virt/kvm/
>>
>>
>
> Most of the patch is just whitespace changes, which don't improve the code
> in any way.  I much prefer patches that fix bugs or add features.
>
Ofcourse everyone prefers bug fixes and new features :-)
I simply looked at greg's "submit a patch" video.
And thought, hey I could do this, and help clean up code.
Cleaner code makes it more accessible
and I get to know where everything is located.
So I am going to continue making patches like these
and become more familiar with the whole kernel.

-- 
Keimpe de Jong
