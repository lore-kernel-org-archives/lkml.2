Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab2C2Wwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:52:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57720 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240Ab2C2Wwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120330095020.a2e01d86c2d09f186c53d63d@canb.auug.org.au>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org>
 <1332994469.3010.7.camel@pasglop> <20120329210117.A9A073E06B4@localhost> <20120330095020.a2e01d86c2d09f186c53d63d@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 29 Mar 2012 16:52:25 -0600
X-Google-Sender-Auth: 3pY0H7Vn_t7fogXqKCZ4mldHlOQ
Message-ID: <CACxGe6sokpFa_KEi+jxPX3caF4CpfxzZ4f53S1Y_+caXVLBNtg@mail.gmail.com>
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

On Thu, Mar 29, 2012 at 4:50 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> On Thu, 29 Mar 2012 15:01:17 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> Moving it back into powerpc land is a step backwards. I've attached a
>> patch that makes it generic instead.  It has been tested on ARM.
>>
>> I've pushed it out to the following branch:
>>
>> git://git.secretlab.ca/git/linux-2.6 irqdomain/merge
>
> I have pulled that into my fixes tree for today (since otherwise my
> builds will break).

Cool.  If that checks out in linux-next, then I'll ask Linus to pull.

BTW, can you add that branch permanently to linux-next?  That's the
branch I'll use when queuing up irqdomain fixes for mainline.

g.
