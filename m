Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1BMPIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:08:18 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:53576 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab1BMPIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:08:14 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: x32-abi@googlegroups.com, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de> <4D5711E0.7020306@zytor.com>
	<87r5bcnwvw.fsf@mid.deneb.enyo.de>
	<AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
Date: Sun, 13 Feb 2011 16:07:57 +0100
In-Reply-To: <AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
	(H. J. Lu's message of "Sun, 13 Feb 2011 05:45:21 -0800")
Message-ID: <87tyg8j7le.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. J. Lu:

>> Actually, I'm wondering if you can do the translation in user space.
>> There already are 32-on-64 implementations in existence, without
>> kernel changes (recent Hotspot, LuaJIT, and probably some more).
>
> Please check out the x32 kernel source and provide feedback.

I still don't understand why you need a separate syscall table.  You
should really be able to run on an unmodified amd64 kernel, in 64 bit
mode.  This would imply that tools like strace don't need any porting
at all (you could just use the amd64 version), and even GDB would
mostly worked unchanged.
