Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1G2V3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:29:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55146 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1G2V3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim=HFbgYPa-2VJWL+e4mEKqkU503A@mail.gmail.com>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
	<BANLkTim=HFbgYPa-2VJWL+e4mEKqkU503A@mail.gmail.com>
Date: Fri, 29 Jul 2011 14:29:29 -0700
Message-ID: <CAMe9rOp+K7xbtgGi8U=dhHFVigQbVmhOWiXRKjp++4Rd8sf_2Q@mail.gmail.com>
Subject: Re: X32 project status update
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

We have settled down on a preliminary system call number
scheme:

1. In kernel, x86-64 and x32 share the same system call slot if they
are the same.
2. First 512 system call slots are reserved for common and x86-64
specific ones. X32 specific system call slots start at 512.
3. All x32 system call numbers have the bit 30 set.

Gibc x32 binary rpms for Fedora 15/x86-64 are available from
the x32 website.  People can try out x32 on Fedora 15.

Thanks.


-- 
H.J.
