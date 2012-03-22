Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657Ab2CVCob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:44:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:57520 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab2CVCoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:44:30 -0400
Message-ID: <1332384249.2982.67.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 22 Mar 2012 13:44:09 +1100
In-Reply-To: <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
References: <1332377206.2982.60.camel@pasglop>
	 <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 19:02 -0700, Linus Torvalds wrote:
> 
> Ok, so this conflicted a bit with the generalized irq-domain stuff
> from Grant Likely, and while I tried to fix it up I can't even
> compile-test the end result, so you really need to verify my merge and
> perhaps send me fixups. Ok?

Ok, I expected some of that, I'll run some tests today.

> Especially the sysdev/mpic.c resolution needs somebody who knows the
> code to verify. Added Grant and Kyle explicitly to the cc..

Thanks !

Cheers,
Ben.

