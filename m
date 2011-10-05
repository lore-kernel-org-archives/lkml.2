Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099Ab1JERFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:05:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41282 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab1JERFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:05:17 -0400
MIME-Version: 1.0
In-Reply-To: <20111005120621.46c24fe4b8f83ac78944b777@canb.auug.org.au>
References: <20111004132614.GA13865@e102109-lin.cambridge.arm.com> <20111005120621.46c24fe4b8f83ac78944b777@canb.auug.org.au>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 5 Oct 2011 18:04:56 +0100
X-Google-Sender-Auth: 1EmzxwwZpcKFHiB0P16OsmbYgro
Message-ID: <CAHkRjk7YBJJO9HW3JC0AUT2-JTyMwj=4=zd==dSG=pfBvCiFNg@mail.gmail.com>
Subject: Re: Changed location for arm-lpae/for-next
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 5 October 2011 02:06, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Tue, 4 Oct 2011 14:26:14 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:
>>
>> Since I don't know when I'll get my account back on kernel.org, I
>> re-instated my tree on linux-arm.org. Could you please pull this tree
>> instead of arm-lpae/for-next:
>>
>>   git://linux-arm.org/linux-2.6.git for-next
>
> OK, I have switched to that from today.  However, that site is also
> inaccessible today :-(

Ah, sorry about that, some IT issues again (looks fine internally). If
you don't mind to change them again, I created two branches on github,
the first one for LPAE and the other for kmemleak:

git://github.com/cmarinas/linux.git for-next
git://github.com/cmarinas/linux.git kmemleak

Thanks.

-- 
Catalin
