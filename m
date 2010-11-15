Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0KOB0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:26:36 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:41630 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab0KOB0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:26:34 -0500
From: James Cloos <cloos@jhcloos.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, Jim <jim876@xs4all.nl>,
        gcc@gcc.gnu.org, Jim Bos <jim876@xs4all.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
In-Reply-To: <4CD97A3D.1040602@xs4all.nl> (Jim's message of "Tue, 09 Nov 2010
	17:43:41 +0100")
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
	<m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>
	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
	<877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com>
	<Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
	<20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com>
	<4CD97A3D.1040602@xs4all.nl>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sun, 14 Nov 2010 19:52:08 -0500
Message-ID: <m31v6nmmr3.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Hashcash: 1:30:101115:linux-kernel@vger.kernel.org::dAAkbLCNp6+9wZds:00000000000000000000000000000000wU2JN
X-Hashcash: 1:30:101115:schwab@redhat.com::dUZAiwXGH4Gtgccs:0000000000000000000000000000000000000000000V+Uwc
X-Hashcash: 1:30:101115:andi@firstfloor.org::h8rf/gnEtmyjbqzD:00000000000000000000000000000000000000000KB2zr
X-Hashcash: 1:30:101115:matz@suse.de::DJk32KM9dwUUHKcH:00003LijD
X-Hashcash: 1:30:101115:dave.korn.cygwin@gmail.com::on+K0ABd1KEeObB7:0000000000000000000000000000000000DF3nq
X-Hashcash: 1:30:101115:richard.guenther@gmail.com::EOrY5+fOybEpYIc0:0000000000000000000000000000000000TZysk
X-Hashcash: 1:30:101115:jim876@xs4all.nl::rahafVOI41H7XiXi:sZjZw
X-Hashcash: 1:30:101115:gcc@gcc.gnu.org::ShoIzfD5uo4f6Zds:0uNJlo
X-Hashcash: 1:30:101115:jim876@xs4all.nl::DAtTR+hrbyKwKFqA:q1j2s
X-Hashcash: 1:30:101115:torvalds@linux-foundation.org::96bMmXMZXarzejcz:0000000000000000000000000000000EL/Ot
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc 4.5.1 running on an amd64 box "cross"-compiling for a P3 i8k fails
to compile the module since commit 6b4e81db2552bad04100e7d5ddeed7e848f53b48
with:

  CC      drivers/char/i8k.o
drivers/char/i8k.c: In function ‘i8k_smm’:
drivers/char/i8k.c:149:2: error: can't find a register in class ‘GENERAL_REGS’ while reloading ‘asm’
drivers/char/i8k.c:149:2: error: ‘asm’ operand has impossible constraints

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
