Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab0I2WDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:03:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49597 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0I2WDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:03:12 -0400
MIME-Version: 1.0
X-Originating-IP: [169.237.7.95]
Date: Wed, 29 Sep 2010 15:03:11 -0700
Message-ID: <AANLkTik8auzhRB00fRWxbmZKOKg+T87ZZa07ydDAGp=f@mail.gmail.com>
Subject: interpreting semantics of ipc system call
From: Andreas Saebjoernsen <andreas@digitalplaywright.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are developing a simulator that can simulate any specimen x86 linux program.
Our simulator has a simulated memory, unlike the concrete memory state of
tools like Valgrind, so that we can do concrete symbolic execution. Instead of
reimplementing the system calls we marshal the system calls called by
the specimen.

I am currently working on marshaling calls to the ipc system call (system
call 117) which has the following signature

int ipc(unsigned int call, int first, int second, int third, void
*ptr, long fifth)

I have a problem interpreting what the size is of the data structure
pointed to by
the 'void*', and I have been unable to locate good documentation or code on the
semantics of this system call.

Could you please help me interpret the size of the data structure
pointed to by the
'void*' or point me to documentation/code for the ipc system call?

kind regards,
Andreas
