Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab1CDMAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:00:12 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45611 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612Ab1CDMAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=p7UsgHs+m3WSctui/dn6qFKpnwFneK2aL2exMa4qqaElJUU+z5wsoq0JzFxVuWxMfL
         uXTK/gtytZI6eor1hdRQmHKdO2LInsRD35f7mNqOKlh+mz4p58h8u4zJ2CFOJUS+c217
         LJVThd3aA2iKSNwyVT7gSUY46R0RCStY7veyQ=
Date: Fri, 4 Mar 2011 19:59:31 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux@kbdbabel.org
Cc: romfs@googlegroups.com, rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: [PATCH]fix a link in Documentation/filesystem/romfs.txt
Message-ID: <20110304115926.GA4104@gmail.com>
Mail-Followup-To: linux@kbdbabel.org, romfs@googlegroups.com,
	rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, greg@kroah.com,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
    I think it is a good patch for Documentation/filesystem/romfs.txt.

   From: Alexander Kurz <linux@kbdbabel.org>

Hello romfs group,
	 I have posted a patch to fix the reference to
the outdated ftp site (which still serves genromfs-0.5.1) in
Documentation/filesystems/romfs.txt last month,
but nobody has picked it up yet.

Does anybody like to forward this?
Thanks, Alexander

Thanks.
Best Regards.
Harry Wei.

Signed-off-by: Alexander Kurz<linux@kbdbabel.org>
Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 Documentation/filesystems/romfs.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/romfs.txt b/Documentation/filesystems/romfs.txt
index 2d2a7b2..3b7ef40 100644
--- a/Documentation/filesystems/romfs.txt
+++ b/Documentation/filesystems/romfs.txt
@@ -17,8 +17,7 @@ comparison, an actual rescue disk used up 3202 blocks with ext2, while
 with romfs, it needed 3079 blocks.
 
 To create such a file system, you'll need a user program named
-genromfs.  It is available via anonymous ftp on sunsite.unc.edu and
-its mirrors, in the /pub/Linux/system/recovery/ directory.
+genromfs. It is available on http://romfs.sourceforge.net.
 
 As the name suggests, romfs could be also used (space-efficiently) on
 various read-only media, like (E)EPROM disks if someone will have the
-- 
1.7.0.4


