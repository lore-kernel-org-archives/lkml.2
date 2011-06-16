Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1FPUIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:08:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52872 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab1FPUIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MScX42Qv7T0d+NXsZjU7xEhNkAZJK9K48ByJscMXR+G/zN1WWtihgzuS3bMnsvtZFW
         LpM50pxbdseYFVTDmkE2VppJLXRHb+OiScuwE+5ysttEOJAkmZ8DQW9Wy+oOEbs5BChu
         VpWmTAlSrQiVrToI4rVDxAo5TIIkOshO6h3KM=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=iKW+XsfSBoPJmZWZOvq4RKa_Yjg@mail.gmail.com>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
 <1302760895-13459-6-git-send-email-vapier@gentoo.org> <20110418082900.GB32457@linux-sh.org>
 <201106161707.32356.arnd@arndb.de> <BANLkTi=iKW+XsfSBoPJmZWZOvq4RKa_Yjg@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 16 Jun 2011 16:07:55 -0400
X-Google-Sender-Auth: JmExSgbvdmggGCWJHk2dagch4Lw
Message-ID: <BANLkTim5fBUmyH-Vo+6zSgoZdXxu-Mq6OA@mail.gmail.com>
Subject: Re: [PATCH 5/5] kgdbts: unify/generalize gdb breakpoint adjustment
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 16:06, Mike Frysinger wrote:
> On Thu, Jun 16, 2011 at 11:07, Arnd Bergmann wrote:
>> This patch is causing build problems now, because the instruction_pointer_set()
>> that is used now is only defined in asm-generic/ptrace.h, which is only
>> used on x86, blackfin and sparc. Every other architecture now fails to
>> build.
>
> a fix was already merged over two weeks ago.  so either your tree is
> out of date,
>
> your tree is out of date.

blah, network died before i could finish editing this

your tree is out of date or you're seeing a different issue and need
to post a full build log
-mike
