Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0FZJUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:20:22 -0400
Received: from v-smtp-auth-relay-3.gradwell.net ([79.135.125.42]:55451 "EHLO
	v-smtp-auth-relay-3.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab0FZJUV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:20:21 -0400
Subject: Atom N270 more efficent with int 0x80 than with syscalls
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Sat, 26 Jun 2010 10:20:11 +0100
Message-ID: <1277544011.24284.14.camel@lithium.local.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I rewrote a small assembler program to test timings and print
out timing informations for various assembly routines. Then I thought to
add tests for timings on int 0x80 and calling via syscalls. 

Now I know int 0x80 calls are expensive on processors such as the
Pentium IV but someone has tested my assembly program with their Atom
N270 1.6GHz system, and int 0x80s calls are actually much quicker than
syscalls on these processors. 

Here's the test program that exposed the timing differences with these
int 0x80 calls and syscalls:
http://www.munted.org.uk/programming/newtimer.zip

Perhaps the kernel could be greatly speeded up on certain processors if
it dynamically adapts to use the quickest type of system calls? 
-- 
http://www.munted.org.uk

One very high maintenance cat living here.
