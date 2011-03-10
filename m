Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1CJLok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:44:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63468 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1CJLoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=prjN5cC+xOnbNrZiPWDJzGHBZ6hk8QoBqLhHVaOBBxZ6ST3QnIqqdONbCVQKaQOIbE
         Usqx1P6iwSP7PWlfZl9CapwaM20oFtEQRC2yjDxDrz6Dv52JewYPXll/xx66hAm7U61S
         zdmbN6Yd9pPC4Hkk6LygUmZJoEcjnOIoW5j60=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110310110931.GF22723@ZenIV.linux.org.uk>
References: <20110310110931.GF22723@ZenIV.linux.org.uk>
Date: Thu, 10 Mar 2011 12:44:37 +0100
Message-ID: <AANLkTi=gv+iT6Lc_ADoBu9_P78ivhmOwLh-+Oki7WmD1@mail.gmail.com>
Subject: Re: [git pull] more vfs fixes for final
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 12:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        Fix for misplaced include in sysctl.h, fixes for ->d_revalidate()
> (a bunch of filesystems are unusable with nfsd at the moment; the real fix
> is to make ->d_revalidate() take flags directly and forget about dereferencing
> nameidata in most of the instances, but that's obviously for the next window
> and oopsen really need to be fixed for -final), missing checks in fallocate()
> and Bruce's patch for inode (temporary) leaks with nfsd.  Please, pull from
>
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
>

Did you really push the new commits?

Last commit here is commit b306419ae08d9def53f2142a37cc0a58622307a8:
"nd->inode is not set on the second attempt in path_walk()"

- Sedat -
