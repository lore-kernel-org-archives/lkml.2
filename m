Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2EERKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 13:10:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49671 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2EERKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 13:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <1798237.g4OIBKAx4s@donald.sf-tec.de>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com> <1798237.g4OIBKAx4s@donald.sf-tec.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 May 2012 10:09:53 -0700
X-Google-Sender-Auth: gxg49VKLRV2VPk9_EEpSw8lHqsY
Message-ID: <CA+55aFxSJbcigdqwoyKQTOV3MDtgcMyDqXtKz3JuJC_SD9v2vw@mail.gmail.com>
Subject: Re: [PATCH] Fix compile failure on PA-RISC
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 11:55 PM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
>
> I did only move the definition of PAGE0 from asm/pdc.h to asm/page.h and fixed
> another bunch of breakage that was detected while fixing this.

I have to say that that sounds like a more natural patch. *Every*
other architecture defines cpu_relax() in <asm/processor.h>, so it
sounds like a bad idea to make PA-RISC any more different than
necessary.

Even if only one or two people actually care.

                     Linus
