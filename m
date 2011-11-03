Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1KCK3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:29:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40157 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1KCK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <20111006095625.c4814b818efdc61842451625@canb.auug.org.au>
References: <20111004132614.GA13865@e102109-lin.cambridge.arm.com>
 <20111005120621.46c24fe4b8f83ac78944b777@canb.auug.org.au>
 <CAHkRjk7YBJJO9HW3JC0AUT2-JTyMwj=4=zd==dSG=pfBvCiFNg@mail.gmail.com> <20111006095625.c4814b818efdc61842451625@canb.auug.org.au>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 3 Nov 2011 10:29:24 +0000
X-Google-Sender-Auth: o7Xx7hbrXYo65YV8Bjc5G3tn2tw
Message-ID: <CAHkRjk4ow5EZyqj3j6yDocsX5BPjDQvrqX1enPfyDt5kp=qxaQ@mail.gmail.com>
Subject: Re: Changed location for arm-lpae/for-next
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 5 October 2011 23:56, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Wed, 5 Oct 2011 18:04:56 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:
>> I created two branches on github,
>> the first one for LPAE and the other for kmemleak:
>>
>> git://github.com/cmarinas/linux.git for-next
>
> I have switched to that from today.
>
>> git://github.com/cmarinas/linux.git kmemleak
>
> And added that from today as well.

I now got my kernel.org account back and I plan to remove the github
tree. You can get the above branches from:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git for-next
git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git kmemleak

(the first one contains the ARM LPAE patches)

Thanks.

-- 
Catalin
