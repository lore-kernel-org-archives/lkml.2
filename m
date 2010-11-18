Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0KRToy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:44:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334Ab0KRTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:44:53 -0500
MIME-Version: 1.0
In-Reply-To: <20101118190205.GB10827@elte.hu>
References: <201011172159.oAHLx1tu001236@hera.kernel.org> <20101117140526.d532b373.randy.dunlap@oracle.com>
 <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
 <20101118094342.GA10382@elte.hu> <AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com>
 <AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com> <20101118190205.GB10827@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 11:44:30 -0800
Message-ID: <AANLkTi=4wwPCOxhiZjRnQqD7yMk+Qyjtc-kbwoszzrj9@mail.gmail.com>
Subject: Re: [build failure] Re: BKL: remove extraneous #include <smp_lock.h>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> I guess it will all go away with CONFIG_BKL so we dont really care so deeply. I'll
> test it.

Randy tested it, and yes, I made a big comment about "the BKL is going
away, so this is ugly" in the commit message.

    Linus
