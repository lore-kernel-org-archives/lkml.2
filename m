Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab1CPETr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:19:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61293 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1CPETm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=hb81JjNZAISq2zhxLUt3ta3D7LhTVPC38Lh143r8yeQsLT7j5LwvyDEX1fvbG8U7ux
         JxMEiQGiwGCt6mbOH2Yyt6NIlSeojLI6KWi00t9vmHeKIOjANXA+8+76IhOOCDX88JCr
         KO1cb2iDBNhVG/sPXeOpot20o5Ib+p+mu8cfI=
MIME-Version: 1.0
In-Reply-To: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
Date: Tue, 15 Mar 2011 21:19:41 -0700
Message-ID: <AANLkTik6XbB9JSFzMxsHnm_6KmR6bz0qBcudKuSuSmcz@mail.gmail.com>
Subject: X32 psABI status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Almost all x32 bugs in kernel, glibc and binutils are fixed:

https://sites.google.com/site/x32abi/

There are no unexpected failures in glibc testsuite. I am
working on remaining GCC bugs.

-- 
H.J.
