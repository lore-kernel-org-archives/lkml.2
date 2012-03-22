Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603Ab2CVCCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:02:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45366 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2CVCCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:02:22 -0400
MIME-Version: 1.0
In-Reply-To: <1332377206.2982.60.camel@pasglop>
References: <1332377206.2982.60.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Mar 2012 19:02:00 -0700
X-Google-Sender-Auth: -rs4KGy4-tGGwApxVS1bGfMqUNI
Message-ID: <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git next branch
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 5:46 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Here's the powerpc batch for this merge window. It is going to be a bit
> more nasty than usual as in touching things outside of arch/powerpc
> mostly due to the big iSeriesectomy :-) We finally got rid of the bugger
> (legacy iSeries support) which was a PITA to maintain and that nobody
> really used anymore.
>
> Here are some of the highlights:

Ok, so this conflicted a bit with the generalized irq-domain stuff
from Grant Likely, and while I tried to fix it up I can't even
compile-test the end result, so you really need to verify my merge and
perhaps send me fixups. Ok?

Especially the sysdev/mpic.c resolution needs somebody who knows the
code to verify. Added Grant and Kyle explicitly to the cc..

                      Linus
