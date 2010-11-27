Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0K0PEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:04:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46269 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0K0PEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:04:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PqKYIfNdELYMOKhb7aNFnltxQgUZux3u1xy3BchgPNp6wws9XmEyr0qwaKYZaOMQkl
         xWsIIO/WBwhu2wt+0JzzUJH6uSOXY/r8psQbuOqK2ik97+Bfv2ZOCSxCS800Q3idVA5A
         9NL8KboYYMpEQodQTh94xF/By4qwatc95Qhpc=
MIME-Version: 1.0
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 17:04:08 +0200
Message-ID: <AANLkTikRDO0C4Giz6vVHeMnHMtOGO5N1gN4wChEwBLpk@mail.gmail.com>
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 12:15 PM, Nick Piggin <npiggin@kernel.dk> wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working

I get:
  CC [M]  fs/cifs/inode.o
fs/cifs/inode.c: In function ‘inode_has_hashed_dentries’:
fs/cifs/inode.c:807: error: ‘dcache_inode_lock’ undeclared (first use
in this function)
fs/cifs/inode.c:807: error: (Each undeclared identifier is reported only once
fs/cifs/inode.c:807: error: for each function it appears in.)
make[3]: *** [fs/cifs/inode.o] Error 1
make[2]: *** [fs/cifs] Error 2
make[1]: *** [fs] Error 2

I used the latest mainline.
