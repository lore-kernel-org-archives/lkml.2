Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1JYVQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 17:16:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51237 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1JYVQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 17:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Tue, 25 Oct 2011 16:16:27 -0500
Message-ID: <CAFkjPTm+D2yFwagVz_2dtXgoW_E692=eFFiXDgipN+BqHfNQmQ@mail.gmail.com>
Subject: [GIT PULL] [Attempt #2] 9p changes fro merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://github.com/ericvh/linux.git for-linus

Aneesh Kumar K.V (4):
      fs/9p: Update zero-copy implementation in 9p
      fs/9p: inode file operation is properly initialized init_special_inode
      fs/9p: Cleanup option parsing in 9p
      net/9p: Convert net/9p protocol dumps to tracepoints

Dan Carpenter (2):
      9p: move dereference after NULL check
      fs/9p: change an int to unsigned int

Nicolae Mogoreanu (1):
      9p: fix 9p.txt to advertise msize instead of maxdata

 Documentation/filesystems/9p.txt |    2 +-
 fs/9p/v9fs.c                     |   33 ++-
 fs/9p/vfs_dir.c                  |   14 +-
 fs/9p/vfs_inode.c                |    2 -
 include/net/9p/9p.h              |   14 +-
 include/net/9p/client.h          |    8 +-
 include/net/9p/transport.h       |   10 +-
 include/trace/events/9p.h        |  176 ++++++++++++++
 net/9p/client.c                  |  469 +++++++++++++++++++++++++++-----------
 net/9p/protocol.c                |   99 +-------
 net/9p/protocol.h                |    4 +-
 net/9p/trans_common.c            |   53 ++---
 net/9p/trans_common.h            |   21 +--
 net/9p/trans_virtio.c            |  319 +++++++++++++++-----------
 14 files changed, 772 insertions(+), 452 deletions(-)
 create mode 100644 include/trace/events/9p.h

The signed tag is: for-linus-3.2-merge-window in that branch

(sorry if I messed anything up in the signing process)

      -eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJOpybdAAoJEGQ1yQUIRaTO0IkQAMax4r3FJBRvG+FpAs1sXgfq
AFiSBBLQ6Y5b/cr33o4l9Y6mL1j1A8QBFThSWEWHMxn6oz1h2lFbGHunWAJGVgOZ
Dvch7vK2ACQlwV/jFyN5CfbmDrFin15U/Olvhy78cTF2crKxCayMvrS/8h45++i1
DEcFcmHHzbPGJUiKrhiZEMw2di9JyNzmBz9jqg5FTmn8U8mESW/7B6uSIiu/CqFS
1hlQ7k8VoMguqXzdjQNPkZkP3iSBAwuv/rf3w6L9def4nPJ8SrV/ALGMXemNsLQF
MVuBOoPToXOEIl7M/fuBlcl21KxCF9Y74fKlKdMZQoSj/aTmULf4Z4Bl86WS717w
gdwIe6kxwLjONwDr546haklxf3pf+ovGgRGnrvaJ7nuYsfVOr7iIUG+WSiiT886G
SPsd07wKo+O1KmzzLKU5mLPiSBr2QFrYyRWxWmZ+GomAPMRbhGrNgk/GOR+GI0/Z
xE+/QNM41EMStvwRtXa6MJT63+9msNf8L2zDUgFSgfNedHHnCWZqCCWzeGwxgcK6
SHCnj7J6VWdqZBHFDYno0KDtwsRca72XZoei1kgUH+epSiWTvZdpgDNeSA0NCqTi
HnxI3vdbH95ptsM/lvljEA/vDo/nYg83LVvWcbFrLlUcUrmq03xftrItABCaQ4+D
mBTzEHrtFUvs7hw17n3N
=zUBe
-----END PGP SIGNATURE-----
