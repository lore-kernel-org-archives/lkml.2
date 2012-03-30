Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab2C3AiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:38:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46822 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021Ab2C3AiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:38:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120330103840.790c6486dbe71e5ff901321e@canb.auug.org.au>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org>
 <1332994469.3010.7.camel@pasglop> <20120329210117.A9A073E06B4@localhost>
 <20120330095020.a2e01d86c2d09f186c53d63d@canb.auug.org.au>
 <CACxGe6sokpFa_KEi+jxPX3caF4CpfxzZ4f53S1Y_+caXVLBNtg@mail.gmail.com> <20120330103840.790c6486dbe71e5ff901321e@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 29 Mar 2012 18:37:47 -0600
X-Google-Sender-Auth: SnbhyVWZZo8-bFiGCOWE5QgUlhs
Message-ID: <CACxGe6tTZDasbQWu6AM_yGS49yUv+yVSnLXV6X8fJHAxHZLdfQ@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        arnd@arndb.de, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 5:38 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> On Thu, 29 Mar 2012 16:52:25 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> Cool.  If that checks out in linux-next, then I'll ask Linus to pull.
>>
>> BTW, can you add that branch permanently to linux-next?  That's the
>> branch I'll use when queuing up irqdomain fixes for mainline.
>
> OK, I have added that branch.   Meanwhile, Linus has merged that branch
> as well, so I will remove it from my fixes tree again :-)

:-D  Thanks Linus.

Stephen, can you verify on one of your ppc machines that
/debug/irq_domain_mapping still works for you?

Thanks,
g.
