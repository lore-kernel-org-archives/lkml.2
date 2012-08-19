Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab2HSAIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 20:08:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45436 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2HSAIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 20:08:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120818193221.GB250@x4>
References: <20120817171354.GA14046@kroah.com> <20120818060934.GA255@x4>
 <20120818163401.GA2013@kroah.com> <1345315025.10014.15.camel@joe2Laptop>
 <20120818185528.GA250@x4> <CA+55aFw48y=bZQq12-ySBiDT=ef6Yuq=eh6HLo6TGqyEK2kPkw@mail.gmail.com>
 <20120818193221.GB250@x4>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Aug 2012 17:08:22 -0700
X-Google-Sender-Auth: 57NLUNpwfTETS3b9xukUurI_cfU
Message-ID: <CA+55aFycrmPy2nX1t6xOXm7r0s63Y=fBHqX56H+T849QAQnttg@mail.gmail.com>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 12:32 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> Yes. Everything is fine again with this patch applied.

Ok, can you write a commit message and sign off on it, and I'll apply
it (or Greg will, either way that message/sign-off would be needed for
proper patch flow).

Thanks,
                 Linus
