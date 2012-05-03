Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2ECGtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:49:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45849 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab2ECGtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:49:07 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120430114410.GB28308@thunk.org>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
 <877gwxacti.fsf@skywalker.in.ibm.com> <20120430114410.GB28308@thunk.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 3 May 2012 18:48:45 +1200
Message-ID: <CAKgNAkjFpA_sm1jxt8ZTWk=y1_ViB5nepha+KeEEtuGAx6LJhQ@mail.gmail.com>
Subject: Re: [PATCH] open(2): document O_PATH
To: "Ted Ts'o" <tytso@mit.edu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted,

On Mon, Apr 30, 2012 at 11:44 PM, Ted Ts'o <tytso@mit.edu> wrote:
> It might also be a good idea to document explicitly whether or not
> things like fstat() and the syscalls to manipulate extended attributes
> are expected to work.

Good point. From some testing, it appears that syscalls such as
fstat() and fgetxattr() fail with EBADF on O_PATH fds. I'll add that
to the text.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
