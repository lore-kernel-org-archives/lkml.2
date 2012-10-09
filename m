Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2JIONh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:13:37 -0400
Received: from mx2.netapp.com ([216.240.18.37]:55423 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2JIONe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:13:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="699156960"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Disintegrate UAPI for nfs
Thread-Topic: [GIT PULL] Disintegrate UAPI for nfs
Thread-Index: AQHNpiJjmS8Jn9en10utTH+NtMCAaZexeVcA
Date: Tue, 9 Oct 2012 14:13:30 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90901876D@SACEXCMBX04-PRD.hq.netapp.com>
References: <30732.1349789436@warthog.procyon.org.uk>
In-Reply-To: <30732.1349789436@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <170E94DC57327D4187239AA8AA349955@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q99EDiKn005438

On Tue, 2012-10-09 at 14:30 +0100, David Howells wrote:
> Can you merge the following branch into the nfs tree please.
> 
> This is to complete part of the Userspace API (UAPI) disintegration for which
> the preparatory patches were pulled recently.  After these patches, userspace
> headers will be segregated into:
> 
> 	include/uapi/linux/.../foo.h
> 
> for the userspace interface stuff, and:
> 
> 	include/linux/.../foo.h
> 
> for the strictly kernel internal stuff.
> 
> ---
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> 
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-nfs-20121009
> 
> for you to fetch changes up to e3dd9a52cb5552c46c2a4ca7ccdfb4dab5c72457:
> 
>   UAPI: (Scripted) Disintegrate include/linux/sunrpc (2012-10-09 09:49:04 +0100)
> 
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
> 
> ----------------------------------------------------------------
> David Howells (2):
>       UAPI: (Scripted) Disintegrate include/linux/nfsd
>       UAPI: (Scripted) Disintegrate include/linux/sunrpc
> 
>  include/linux/nfsd/Kbuild           |   5 --
>  include/linux/nfsd/debug.h          |  31 +--------
>  include/linux/nfsd/export.h         |  52 +--------------
>  include/linux/nfsd/nfsfh.h          | 111 +-------------------------------
>  include/linux/nfsd/stats.h          |   8 +--
>  include/linux/sunrpc/Kbuild         |   1 -
>  include/linux/sunrpc/debug.h        |  39 +-----------
>  include/uapi/linux/nfsd/Kbuild      |   5 ++
>  include/{ => uapi}/linux/nfsd/cld.h |   0
>  include/uapi/linux/nfsd/debug.h     |  40 ++++++++++++
>  include/uapi/linux/nfsd/export.h    |  58 +++++++++++++++++
>  include/uapi/linux/nfsd/nfsfh.h     | 122 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/nfsd/stats.h     |  17 +++++
>  include/uapi/linux/sunrpc/Kbuild    |   1 +
>  include/uapi/linux/sunrpc/debug.h   |  48 ++++++++++++++
>  15 files changed, 296 insertions(+), 242 deletions(-)
>  rename include/{ => uapi}/linux/nfsd/cld.h (100%)
>  create mode 100644 include/uapi/linux/nfsd/debug.h
>  create mode 100644 include/uapi/linux/nfsd/export.h
>  create mode 100644 include/uapi/linux/nfsd/nfsfh.h
>  create mode 100644 include/uapi/linux/nfsd/stats.h
>  create mode 100644 include/uapi/linux/sunrpc/debug.h

These files look like they are mainly NFS server related, so perhaps it
is better to merge through Bruce's tree.

Bruce?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
