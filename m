Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1FQDNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:13:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51724 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab1FQDNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=XF00Ru7ZMm7ZxsRv3xWtj0JSrQ5VFwFUg/cJex3C2JsBSw3Jsz8DqTNxaWut9M6+DA
         MNKjgpBUjPAzQPTJ1lWE6KJ9ZjZuK+2l3RWg9jJkvQ73LE8wzZdPkfLgh9kjGiblxWlC
         Oye4KVzspUTeS16zqzu0Ray0BdDud3iWPevBk=
MIME-Version: 1.0
In-Reply-To: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
Date: Thu, 16 Jun 2011 20:13:47 -0700
Message-ID: <BANLkTim=HFbgYPa-2VJWL+e4mEKqkU503A@mail.gmail.com>
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

With the latest x32 kernel, glibc, gcc and gdb, everything
works, including core dump and vDSO.

I'd like to see x32 kernel system call numbers be finalized
so that people don't have to recompile everything if the final
x32 kernel system call numbers are different from the current
one.

I started to prepare merging GCC x32 branch with trunk followed
by glibc and gdb patches.  I have sent 7 middle-end patches so
far. I got feedbacks on 3 of them.  I checked in one patch.  I
provided one update and I am investigating the 3rd feedback.
I have more middle-end patches.

-- 
H.J.
