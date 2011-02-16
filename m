Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1BPLOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:14:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44420 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1BPLOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:14:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q/ZEAEaaTdY5LCYCre6ciC+b8AVpdQtzkCilnqH2kjukg8esr7HuA+TA7CYS7N10+Z
         tT/Gdf803dGoMGq6DcijCFMTK2d8Wf+ujeOr4FtYee8/3/MST5rvtAtFXohguEh++x4t
         oZyqHIrCDNtwK9acjBXg+vRvuYlHOKcOpqeYQ=
Subject: Re: Linux 2.6.38-rc5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 12:14:02 +0100
Message-ID: <1297854842.3201.197.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 15 février 2011 à 20:16 -0800, Linus Torvalds a écrit :
> Another week, another -rc.
> 
> Nothing much stands out here - we've fixed some regressions
> (including, hopefully, a BUG_ON() due to the new RCU filename lookup
> that Ubuntu people saw), and things look fairly normal.

Using this kernel on my dev machine (2x4x2 cpus), I hit BUG_ON() in
fs/namei.c:1461 on my kernel build (make -j16)

BUG_ON(inode != next.dentry->d_inode)

I do have DEBUG_PAGEALLOC and LOCKDEP on



