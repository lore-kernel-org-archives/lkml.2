Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1BMIsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 03:48:20 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:55045 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab1BMIsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 03:48:16 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: x32-abi@googlegroups.com
Cc: "H.J. Lu" <hjl.tools@gmail.com>, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de> <4D5711E0.7020306@zytor.com>
Date: Sun, 13 Feb 2011 09:48:03 +0100
In-Reply-To: <4D5711E0.7020306@zytor.com> (H. Peter Anvin's message of "Sat,
	12 Feb 2011 15:04:00 -0800")
Message-ID: <87r5bcnwvw.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin:

> On 02/12/2011 01:10 PM, Florian Weimer wrote:
>> Why is the ia32 compatiblity kernel interface used?
>
> Because there is no way in hell we're designing in a second
> compatibility ABI in the kernel (and it has to be a compatibility ABI,
> because of the pointer size difference.)

Actually, I'm wondering if you can do the translation in user space.
There already are 32-on-64 implementations in existence, without
kernel changes (recent Hotspot, LuaJIT, and probably some more).
