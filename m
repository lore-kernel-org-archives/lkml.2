Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1KGUWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:22:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55533 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1KGUWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:22:09 -0500
MIME-Version: 1.0
In-Reply-To: <CADMYwHwikr+UYh6t2trpzGE8Qwy8JMxqDHnHadv33+8KJT+hcw@mail.gmail.com>
References: <20111107173318.12d4a5ce67a522b000d4a78c@canb.auug.org.au>
 <20111107191200.GH30282@windriver.com> <CAP=VYLqp1KcsE3UMt2-xuMp-gwtyLWfwdNmzxBvZZ=bZT_6E2w@mail.gmail.com>
 <CADMYwHwikr+UYh6t2trpzGE8Qwy8JMxqDHnHadv33+8KJT+hcw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 7 Nov 2011 22:21:47 +0200
X-Google-Sender-Auth: O5MhJppBXfbGKhJAzzPXekDBJOc
Message-ID: <CADMYwHzCw5c25DAqw4dE7mKf8yMfMdH29quSTBDQhiv3WJ0G6Q@mail.gmail.com>
Subject: Re: [GIT PULL] Left overs from the module.h split merge
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 9:38 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Mon, Nov 7, 2011 at 9:26 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> For completeness, the above also should have listed including this:
>>
>> Axel Lin (1):
>>      hwspinlock/u8500: include linux/module.h
>
> This one is already queued up in hwspinlock fixes together with 2
> other fixes from Axel.

Ok, I've dropped it from hwspinlock fixes, so feel free to push it via
your tree. This gives us the same result with less emails :)
