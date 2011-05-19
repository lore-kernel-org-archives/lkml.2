Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1ESDBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:01:25 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37087 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1ESDBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=q/LquCWTKeZ/yl47zFGuRuGxrzj09r9JLGCyPyfcZoeV0VmtOWfG9JC6odzSYXXzCK
         j7ENf+13MogR6gUgv+O//IzuDSku84CEhTLVMrivOduKIJYqgr9/Oc8VLjT5LgTkeLU5
         6Dsy6YSnqkXEDqC2l9ljCG5irs416XdyavnIA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105182234130.14430@xanadu.home>
References: <201105181047.17309.arnd@arndb.de> <BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com>
 <alpine.LFD.2.00.1105182234130.14430@xanadu.home>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 May 2011 11:01:03 +0800
Message-ID: <BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,
Thanks for your reply.

2011/5/19 Nicolas Pitre <nico@fluxnic.net>:
> On Thu, 19 May 2011, Barry Song wrote:
>
>> does it mean if we want to add a new SoC plat/mach, we will send
>> patches againest this tree?
>
> Yes.  Or against latest mainline tree from Linus.
>
>> will this tree merge into rmk's tree? then rmk's tree will only manage
>> arm common codes?
>
> Something like that.  The exact details will be fleshed out as we go.
> The idea is to give a round of review from a higher point of view to
> make sure no opportunities for code reuse is missed, etc.  The mechanics
> of how this code transitions from this tree into mainline during the
> merge window is secondary.

i asked this because we wanted to send the source codes of
CSR(http://www.csr.com) to upstream as i have told you in LDS. it
looks like we need to follow the below new changes to make our source
codes acceptable?
1. arm device tree
2. new pinmux framework from Linus Walleij
3. move GPIO from plat/mach to drivers/gpio?

>
>
> Nicolas
-barry
