Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1KXX6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:58:22 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42481 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab1KXX6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:58:21 -0500
MIME-Version: 1.0
In-Reply-To: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
Date: Thu, 24 Nov 2011 15:58:19 -0800
Message-ID: <CAMe9rOom59dS1X6tfUec36O3Q0jFDZiE36Pesw3+Nvr7kyTUqg@mail.gmail.com>
Subject: X32 project status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the x32 project status update:

https://sites.google.com/site/x32abi/

There are several changes:

1. We changed x32 kernel to use the 64bit filesystem interface (LFS) as well as
64bit time_t.  We are targeting Linux kernel 3.3.
2. I backported x32 support to glibc 2.14, 2.13, 2.12 and 2.11.  Since
glibc 2.11
is the first x32 release now, the x32 minimum ABI is changed from GLIBC_2.14
to GLIBC_2.11, which require recompiling all existing x32 binaries.
3. I am implementing address-size override:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=50797

The result shows that it can improve SPEC CPU performance by another 5%
over the current x32 implementation.  I am putting this on hjl/x32/addr32 branch
at

http://gcc.gnu.org/git/?p=gcc.git;a=summary

I also backported it to GCC 4.6 on hjl/x32/gcc-4_6-branch branch.


-- 
H.J.
