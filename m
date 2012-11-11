Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2KKKXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 05:23:09 -0500
Received: from canardo.mork.no ([148.122.252.1]:35432 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab2KKKXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 05:23:06 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: richjunk@pacbell.net
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH usb-linus] USB: keyspan: fix typo causing GPF on open
Organization: m
References: <509D5BCD.3010901@pacbell.net>
	<1352538822-28221-1-git-send-email-bjorn@mork.no>
	<509EFDA3.4060900@pacbell.net>
Date: Sun, 11 Nov 2012 11:22:55 +0100
In-Reply-To: <509EFDA3.4060900@pacbell.net> (Richard's message of "Sat, 10 Nov
	2012 17:21:39 -0800")
Message-ID: <87y5i8xwu8.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard <richjunk@pacbell.net> writes:

> Bjørn:
>
> I patched keyspan.c using your below supplied diff in 3.6.6 (I'm not
> using git.)  The patch WORKS for me.  (I tested using minicom and the
> two programs that usually access the Keyspan serial device.)

Thanks for testing.  Good to know that this really was the problem you
were facing.

As you might have guessed, neither Johan nor I have the hardware to test
this driver. So your bug report and testing is extremely valuable.

> Thank you for the quick fix.

And thank you for an excellent bug report and quick testing.  The fact
that you could describe exactly which stable releases this appeared in
narrowed it down to just a single commit. And describing exactly what
happened narrowed it down to just a few possible places within that
commit.  This was the main reason the bug could be fixed this fast.

> Will this show up in 3.6.7?

That's for Greg to answer.  But don't be surprised if this came in too
late for 3.6.7.  All fixes for stable has to go through mainline first.



Bjørn
