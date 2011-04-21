Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1DUJIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:08:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43133 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1DUJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=LDqzJaLJmBum26OOvqBYmeuemfThDzFEg4Y+x4qsLZEPL/lePCMPG4mF63RucWH1kn
         0LGKKNapJ9moBtNZMpDSwEShqRKtifDS2j1PUeb53Y661eODJHrElhMFTDRstGB8l/8/
         zIuoa+QIbcyPTDPXmkyNoWMwkQdaLRTmnpF70=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Phillip Lougher <phillip.lougher@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
	<BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
	<BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
	<BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
	<C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
	<BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com>
	<87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
	<BANLkTinXVDrLnMOo17pqua5+38yQsezG6g@mail.gmail.com>
	<87tydtm41s.fsf@tucsk.pomaz.szeredi.hu>
	<BANLkTikJ_7ZZ+1uC=0RBmKmxqFhVyLiYsw@mail.gmail.com>
Date: Thu, 21 Apr 2011 11:08:02 +0200
In-Reply-To: <BANLkTikJ_7ZZ+1uC=0RBmKmxqFhVyLiYsw@mail.gmail.com> (Michal
	Suchanek's message of "Thu, 21 Apr 2011 08:59:54 +0200")
Message-ID: <871v0wvuod.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Suchanek <hramrach@centrum.cz> writes:

> Can you put up a branch with both overlayfs and xattrs?
>
> I would like to point people at a repo with working implementation and
> mirroring the kernel tree to add one patch is a bit overkill.

Okay, added the tmpfs-xattr patch to the overlayfs.v8 branch.

Thanks,
Miklos
