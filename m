Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2CVENs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 00:13:48 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61701 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2CVENr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 00:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
References: <1332377206.2982.60.camel@pasglop> <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 21 Mar 2012 21:13:24 -0700
Message-ID: <CAGZ=bqJU5nd71ei2OatsRRqr_hLdPQLiE1MXD7VEtb9n0v7yaw@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git next branch
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 19:02, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 21, 2012 at 5:46 PM, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>> Here's the powerpc batch for this merge window. It is going to be a bit
>> more nasty than usual as in touching things outside of arch/powerpc
>> mostly due to the big iSeriesectomy :-) We finally got rid of the bugger
>> (legacy iSeries support) which was a PITA to maintain and that nobody
>> really used anymore.
>>
>> Here are some of the highlights:
>
> Ok, so this conflicted a bit with the generalized irq-domain stuff
> from Grant Likely, and while I tried to fix it up I can't even
> compile-test the end result, so you really need to verify my merge and
> perhaps send me fixups. Ok?
>
> Especially the sysdev/mpic.c resolution needs somebody who knows the
> code to verify. Added Grant and Kyle explicitly to the cc..

As I'm no longer at Boeing, my old @boeing.com address probably
bounces.  Please feel free to send stuff to my personal address:
kyle@moffetthome.net

I don't know that I'll be much help, but I will try to look over the
resolved mpic code this evening to see if anything jumps out at me.

Cheers,
Kyle Moffett
