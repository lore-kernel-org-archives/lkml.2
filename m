Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2LRSCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:02:33 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55289 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2LRSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:02:32 -0500
MIME-Version: 1.0
In-Reply-To: <1355787094.5397.30.camel@pasglop>
References: <1355517897.19932.136.camel@pasglop> <1355787094.5397.30.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Dec 2012 10:02:11 -0800
X-Google-Sender-Auth: fE3F1UfW0MAwjku1tsYvBvqG6tA
Message-ID: <CA+55aFw-cRskrvW07FVJd9HfrBhn41Ogi1Vv_v1U12zahzFu=A@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git next branch
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 3:31 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sat, 2012-12-15 at 07:44 +1100, Benjamin Herrenschmidt wrote:
>> Hi Linus !
>>
>> Finally managed to get my head away from some other distractions
>> to put this pull request together, sorry for the lateness :-)
>>
>> The main highlight is probably some base POWER8 support. There's
>> more to come such as transactional memory support but that will
>> wait for the next one. (next merge window)
>>
>> Overall it's pretty quiet, or rather I've been pretty poor at
>> picking things up from patchwork and reviewing them this time
>> around and Kumar no better on the FSL side it seems...
>
> So it looks like I'm an idiot and totally failed to put your email
> address on the CC list of that pull request :-)

.. yeah, that helps.

Anyway, I've pulled it in, but got a conflict on the kernel_thread
cleanups from Al. And since the conflict was in the powerpc assembly
code that I don't really know the details of, I did the
straightforward resolve of it, but I'd like you to check it out.

(I haven't pushed it out yet, I'm waiting for the allmodconfig to
finish compiling, so if you see this email quickly, but don't see the
powerpc merge yet, just wait a few minutes)

                Linus
