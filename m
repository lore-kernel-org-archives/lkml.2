Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2DVWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 18:09:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41628 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2DVWJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 18:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <1335129679.12741.4.camel@deneb.redhat.com>
References: <1334958476-6296-1-git-send-email-msalter@redhat.com>
 <CAMjpGUe+CMkHP7owZym_6c2RDvgLzj8t+ZpLBuqQ0euk+ArV2Q@mail.gmail.com> <1335129679.12741.4.camel@deneb.redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 22 Apr 2012 18:09:03 -0400
Message-ID: <CAMjpGUd1+8aHsLp-eipVbRxOiSULPTgMBatxSPPm7tasq226-w@mail.gmail.com>
Subject: Re: [PATCH] C6X: add support to build with BINFMT_ELF_FDPIC
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 17:21, Mark Salter wrote:
> On Sat, 2012-04-21 at 01:01 -0400, Mike Frysinger wrote:
>> On Fri, Apr 20, 2012 at 17:47, Mark Salter wrote:
>> > --- a/fs/Kconfig.binfmt
>> > +++ b/fs/Kconfig.binfmt
>> >
>> >  config BINFMT_ELF_FDPIC
>> >        bool "Kernel support for FDPIC ELF binaries"
>> >        default y
>> > -       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU))
>> > +       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU) || TMS320C6X)
>>
>> shouldn't the main arch symbol be "C6X" to match arch/c6x/ ?
>
> It probably should have been. Most architectures use that convention but
> there are notable exceptions like powerpc and sh.

seems like it'd be fairly trivial to convert it.  there aren't many
references in the kernel tree to TMS320C6X.
-mike
