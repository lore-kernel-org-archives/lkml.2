Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1BLTlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:41:22 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57870 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab1BLTlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=B8S5OzlIkW0LLQjHOBUV9FAvuOa+Hp/cgaK8EeqEQiew03LqKhsJgrit45GhyXfCRf
         BDJu0utgSjHcAqQdRgZxAaMxVqHPYQLPu/FNx4rJOUHZYpxe2ckxEEDWHEtJ4zO/YUlN
         N1MiENmz7MpeRHMWd77uaY5UL1Yi5xWIOszDs=
MIME-Version: 1.0
Date: Sat, 12 Feb 2011 11:41:01 -0800
Message-ID: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
Subject: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We made lots of progresses on x32 pABI:

https://sites.google.com/site/x32abi/

1. Kernel interface with syscall is close to be finalized.
2. GCC x32 branch is stabilizing.
3. The Bionic C library works with the syscall kernel interface.

The next major milestone will be x32 glibc port.

-- 
H.J.
