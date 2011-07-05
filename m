Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1GELkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:40:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:59633 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab1GELkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:40:09 -0400
From: Richard Weinberger <richard@nod.at>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/4] uml: cow_user.c warning corrections
Date: Tue, 5 Jul 2011 13:40:04 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: Vitaliy Ivanov <vitalivanov@gmail.com>, Jeff Dike <jdike@addtoit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
References: <1309821341.4527.5.camel@vitaliy-Vostro-1400> <201107051331.15504.richard@nod.at> <CAMuHMdWWPiFTwQ+0Et8eZZbCy-DtzRMeK=-rFY_NfEWWjYrZ2Q@mail.gmail.com>
In-Reply-To: <CAMuHMdWWPiFTwQ+0Et8eZZbCy-DtzRMeK=-rFY_NfEWWjYrZ2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107051340.04949.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 05 Juli 2011, 13:38:05 schrieb Geert Uytterhoeven:
> On Tue, Jul 5, 2011 at 13:31, Richard Weinberger <richard@nod.at> wrote:
> > Am Dienstag 05 Juli 2011, 13:10:34 schrieb Vitaliy Ivanov:
> >> On Tue, Jul 5, 2011 at 12:28 PM, Richard Weinberger <richard@nod.at> wrote:
> >> > Am Dienstag 05 Juli 2011, 01:15:41 schrieb Vitaliy Ivanov:
> >> >> From 6201d3e862fca8670b206338dc90303ea0acc77d Mon Sep 17 00:00:00
> >> >> 2001 From: Vitaliy Ivanov <vitalivanov@gmail.com>
> >> >> Date: Tue, 5 Jul 2011 01:57:51 +0300
> >> >> Subject: [PATCH 1/4] uml: cow_user.c warning corrections
> >> >> MIME-Version: 1.0
> >> >> Content-Type: text/plain; charset=UTF-8
> >> >> Content-Transfer-Encoding: 8bit
> >> >> 
> >> >> arch/um/drivers/cow_user.c: In function ‘absolutize’:
> >> >> arch/um/drivers/cow_user.c:189:7: warning: ignoring return value of
> >> >> ‘chdir’, declared with attribute warn_unused_result
> >> > 
> >> > What compiler flags are you using?
> >> > Using the default settings this warning does not show up.
> >> > Most of the "ignoring return value" are totally useless.
> >> 
> >> chdir is defined with warn_unused_result attribute and my gcc on
> >> Ubuntu 11.04 issues warnings.
> >> I don't use any additional flags on compiling UML.
> > 
> > Ah, because of -D_FORTIFY_SOURCE=2, right?
> > Then your patches makes sense.
> 
> I also saw it, with gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5).
> I never used FORTIFY_SOURCE.
>

Ubuntu uses FORTIFY_SOURCE per default.

Thanks,
//richard
