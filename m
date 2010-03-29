Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0C2QAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:00:12 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59825 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0C2QAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:00:07 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Luca Barbieri <luca.barbieri@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	<g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
	<b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
	<ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
	<a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
	<ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
	<a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
	<b2cc26e41003270450w1a90f9b2j5cbbae9726122b4e@mail.gmail.com>
	<a36005b51003270505s42b5e69co14d2acbb27dc204a@mail.gmail.com>
	<b2cc26e41003290740i5c548cabgc95d91958cd1075a@mail.gmail.com>
X-Yow: Hey, I LIKE that POINT!!
Date: Mon, 29 Mar 2010 18:00:01 +0200
In-Reply-To: <b2cc26e41003290740i5c548cabgc95d91958cd1075a@mail.gmail.com>
	(Olaf van der Spek's message of "Mon, 29 Mar 2010 16:40:36 +0200")
Message-ID: <m2k4svuni6.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf van der Spek <olafvdspek@gmail.com> writes:

> File not found is a very common error message with a pretty will
> understood meaning.

And perfectly applicable here (as you write yourself in the subject).

> Overloading another error code would avoid this confusion, especially
> since it's far less used.

Changing a well understood error number into a totally misleading one
only increases confusion.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
