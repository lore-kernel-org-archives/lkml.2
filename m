Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2GBXBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 19:01:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56090 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2GBXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 19:01:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120702224648.GA20361@tassilo.jf.intel.com>
References: <20120702224648.GA20361@tassilo.jf.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jul 2012 16:01:24 -0700
X-Google-Sender-Auth: 8At7wZcru9p0fPyI5ETzuC2-MTI
Message-ID: <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 3:46 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> One of my test systems has a new 20s+ boot delay in 3.5rc*
> It takes the floppy driver that long to determine I don't
> have a floppy

Can you enable debug output ("floppy=debug" iirc) to give more details
of what happens leading up to the delay? Maybe the timing of the debug
messages would give some hints too..

The fact that reverting the patch on current -git doesn't actually
help makes me curious. And means that we can't fix it by reverting, so
we really do have to figure out what's going on.

                Linus
