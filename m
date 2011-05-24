Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab1EXBq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:46:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45681 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1EXBqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AWZBiqqWwtwhJ+Xe8iydNxsrJGjJdXGpbzQ90kjENyPy1ty+b9Fd+gTacKpPsdtbce
         Z6Jyr6v5MWsckJXDEwPEIHkijF+yvbBqGZJxO83eqCv71ufLe1VbRwD0d8H3lziN/W2L
         rv+Yp5DVYbbI+5BBogdIyMWX6nPHLqXnBDx0o=
MIME-Version: 1.0
In-Reply-To: <BANLkTimKjtns7oFNMTLbnbyAkKi679ui5A@mail.gmail.com>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-6-git-send-email-andi@firstfloor.org> <BANLkTimKjtns7oFNMTLbnbyAkKi679ui5A@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 23 May 2011 21:46:02 -0400
Message-ID: <BANLkTik8XZnQ7T4X=V3VPY6Ap9R+Xcm3iQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] Hook up sysconf syscall for all architectures
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 22:23, Mike Frysinger wrote:
> On Fri, May 13, 2011 at 19:24, Andi Kleen wrote:
>>  arch/blackfin/include/asm/unistd.h     |    3 ++-
>>  arch/blackfin/mach-common/entry.S      |    1 +
>
> i wish more people would wire up new syscalls for arches ;)
>
> i dont recall off the top of my head acking any other pending new
> syscall which would cause a conflict, so:
> Acked-by: Mike Frysinger <vapier@gentoo.org>
>
> i generally wait for syscalls to hit mainline before i wire them up myself

i'm wiring up sendmmsg on Blackfin systems and will be pushing in a
day or two, so this will need a little tweaking after that hits
mainline
-mike
