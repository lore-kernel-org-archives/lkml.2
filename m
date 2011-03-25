Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1CYV7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:59:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51416 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1CYV7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uW3FDPLEI2W3Xc0qjBXZhZnb2Ef7cyzQaqT9LDQkdMTSuAeQ078U5/KQU2kkLGeOc4
         CAbmpvjUFYpYYrUDagNpE3ChyB0vkdU8LPHgsUk8yf0MIz2lsJB0xYFek21lDvybnZ2f
         QR1T8xNKkMT0WUUffTSIbuiH/BhY9ohfgLEpY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103252246040.31464@localhost6.localdomain6>
References: <20110325133039.521553268@linutronix.de> <20110325133203.039794496@linutronix.de>
 <AANLkTinmwi8qa2_OFWz7o2sJoa04cK8Kod0QvpwvcBgm@mail.gmail.com>
 <AANLkTinsfJVF0wFiyZ=D=nM6gGVnpA8h9SyeoSRcnyqm@mail.gmail.com> <alpine.LFD.2.00.1103252246040.31464@localhost6.localdomain6>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 17:58:43 -0400
X-Google-Sender-Auth: 2Zv87nTZAbO6TVFFxwWCnD5Kask
Message-ID: <AANLkTi=fV+UtmZda+o7HhGXfh1vQKB=Xk=XVsULVixQh@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [patch 2/2] bfin: Convert irq namespace
To: Thomas Gleixner <tglx@linutronix.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 17:47, Thomas Gleixner wrote:
> On Fri, 25 Mar 2011, Mike Frysinger wrote:
>> On Fri, Mar 25, 2011 at 17:34, Mike Frysinger wrote:
>> > On Fri, Mar 25, 2011 at 09:32, Thomas Gleixner wrote:
>> >> -       __set_irq_handler_unlocked(irq, handle);
>> >> +       __irq_set_handler_locked(irq, handle);
>> >
>> > looks like a typo in your patch ?  should still be unlocked right ?
>>
>> although that still doesnt fix the build failure for me ...
>>
>> arch/blackfin/mach-common/ints-priority.c: In function ‘bfin_set_irq_handler’:
>> arch/blackfin/mach-common/ints-priority.c:562: error: implicit
>> declaration of function ‘__irq_set_handler_unlocked’
>
> Sorry the patch is correct, but it depends on a pending pull
> request. I hope that hits linus tree tonight.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/urgent

OK, i'll look at the patches tomorrow then ;)
-mike
