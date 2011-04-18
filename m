Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1DRSTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:19:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51883 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1DRSTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=LWBNPB6NQI/5aTbKWKxonByTwNKEAbo218vf/VUMkzRVX8CijG46Xe2BoXZ3ZTnCuP
         U8EhGn+HfFwoB92K+wSFASDGiw+OGtT9k3c/SavzNjN6uf2sT7r978l8E6SLB4RjmLAL
         QdFUmlOdz+8lvmBnBWs6dmY/SqcQia7HBQCXk=
MIME-Version: 1.0
In-Reply-To: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Mon, 18 Apr 2011 20:19:16 +0200
X-Google-Sender-Auth: SqoPuuIHbEADlY86uxiYoAS_Ot8
Message-ID: <BANLkTin9OP7JA-CUAezFNyhYRWB9_NXf0A@mail.gmail.com>
Subject: Re: [PATCH 0/6] overlay filesystem
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2011 18:00, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Here's an updated version of the overlay filesystem.
>
> Git tree is here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v8
>

Can't build this one:


  CC [M]  fs/overlayfs/copy_up.o
  CC [M]  fs/qnx4/inode.o
fs/overlayfs/copy_up.c: In function 'ovl_read_symlink':
fs/overlayfs/copy_up.c:135: error: implicit declaration of function 'get_fs'
fs/overlayfs/copy_up.c:135: error: incompatible types when assigning
to type 'mm_segment_t' from type 'int'
fs/overlayfs/copy_up.c:136: error: implicit declaration of function 'set_fs'
fs/overlayfs/copy_up.c:136: error: implicit declaration of function 'get_ds'
  CC [M]  fs/quota/quota_v1.o
make[3]: *** [fs/overlayfs/copy_up.o] Error 1
make[2]: *** [fs/overlayfs] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC [M]  fs/quota/quota_v2.o
  CC [M]  fs/quota/quota_tree.o
  CC [M]  fs/qnx4/dir.o
  CC [M]  fs/qnx4/namei.o
  CC [M]  fs/qnx4/bitmap.o
  LD [M]  fs/qnx4/qnx4.o
make[1]: *** [fs] Error 2
make[1]: *** Waiting for unfinished jobs....

Possibly a missing include somewhere?

Thanks

Michal
