Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab1LGEpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 23:45:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45936 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab1LGEpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 23:45:12 -0500
Date: Wed, 7 Dec 2011 04:45:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Johansen <john.johansen@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207044510.GY2203@ZenIV.linux.org.uk>
References: <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <4EDED96E.7000106@canonical.com>
 <4EDEEAE1.2060304@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDEEAE1.2060304@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 08:26:09PM -0800, John Johansen wrote:

> Reviewed-by: John Johansen <john.johansen@canonical.com>

Umm... assuming that's an ACK, the damn thing is in
git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Linus, could you pull it?

Shortlog:
Al Viro (1):
      fix apparmor dereferencing potentially freed dentry, sanitize __d_path() API

Diffstat:
 fs/dcache.c                |   71 +++++++++++++++++++++++++++----------------
 fs/namespace.c             |   20 +++++++-----
 fs/seq_file.c              |    6 ++--
 include/linux/dcache.h     |    3 +-
 include/linux/fs.h         |    1 +
 security/apparmor/path.c   |   65 +++++++++++++++++++++++----------------
 security/tomoyo/realpath.c |    3 +-
 7 files changed, 100 insertions(+), 69 deletions(-)

