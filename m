Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab0JDB71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 21:59:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55615 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0JDB70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 21:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lfYKa4G9a8cNu41B0gn7Kw2bo1c4fPuLoOmZ+8t5TA6xDNLYtEW8RhVtwYaDKXtQ72
         t/6wX7B/XF0Xx/HmLiEhAO8ls/KUFVDMmTQfvi/WUdttmUp5AOfVAjfixoEcjYnpPHq0
         sFm6+si+z/9jIodAFzUf6zPZSuO6xIfgr0bKU=
Date: Mon, 4 Oct 2010 10:03:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Frank Coldwell <junkdnaseq@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gcc compile kernel 2.6 module
Message-ID: <20101004020357.GA5189@cr0.nay.redhat.com>
References: <AANLkTi=fH924fybfmSpxyOu5Vm8Ny9cSyMGWcQN3dvvD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=fH924fybfmSpxyOu5Vm8Ny9cSyMGWcQN3dvvD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 03:31:01PM +0400, Frank Coldwell wrote:
>Hi all,
>
>Does anybody know how should look gcc compilation line
>to compile kernel module for kernel 2.6
>
>In 2.4 it looks like this:
>----------------------------------------------------
>TARGET := hello-1
>WARN := -W -Wall -Wstrict-prototypes -Wmissing-prototypes
>INCLUDE := -isystem /lib/modules/`uname -r`/build/include
>CFLAGS := -O2 -DMODULE -D__KERNEL__ ${WARN} ${INCLUDE}
>CC := gcc-3.0
>
>${TARGET}.o: ${TARGET}.c
>
>.PHONY: clean
>
>clean:
>rm -rf ${TARGET}.o

In 2.6, it would be much simpiler, kbuild has some pre-defined
variables for you to use, so you don't need to, e.g. specify
INCLUDE and CFLAGS in this way.

Please read Documentation/kbuild/*.
