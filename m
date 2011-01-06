Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1AFMEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:04:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36450 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1AFMEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=LCdet+23eCSJ+434FqKxuZiko0EqPk0hqFz5dCGSBapUZP1yoxAZ2NPyf6YaY9k5cS
         rA6VGzaBZ7B8e9ORx2EAaIkfr+gnRG12RAt/1Tf2SmZcpOYZcPSI62aLNLl5Mh7g2G4q
         RaS/4HTdysRuQwHN+Fhpl9IeveoOLKbpkPPEQ=
Message-ID: <4D25AEEE.1050401@gmail.com>
Date: Thu, 06 Jan 2011 13:00:46 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after several reviews is time to submit the code for mainline. Thanks to
CELF to believe and support actively the project and thanks to Tim Bird.

Here the stats:

 Documentation/filesystems/pramfs.txt |  179 ++++++
 Documentation/filesystems/xip.txt    |    2 +
 arch/Kconfig                         |    3 +
 arch/x86/Kconfig                     |    1 +
 fs/Kconfig                           |    8 +-
 fs/Makefile                          |    1 +
 fs/pramfs/Kconfig                    |   72 +++
 fs/pramfs/Makefile                   |   14 +
 fs/pramfs/acl.c                      |  433 +++++++++++++
 fs/pramfs/acl.h                      |   86 +++
 fs/pramfs/balloc.c                   |  147 +++++
 fs/pramfs/desctree.c                 |  181 ++++++
 fs/pramfs/desctree.h                 |   44 ++
 fs/pramfs/dir.c                      |  208 +++++++
 fs/pramfs/file.c                     |  326 ++++++++++
 fs/pramfs/inode.c                    |  848 ++++++++++++++++++++++++++
 fs/pramfs/ioctl.c                    |  121 ++++
 fs/pramfs/namei.c                    |  371 ++++++++++++
 fs/pramfs/pram.h                     |  269 +++++++++
 fs/pramfs/pramfs_test.c              |   47 ++
 fs/pramfs/super.c                    |  940 +++++++++++++++++++++++++++++
 fs/pramfs/symlink.c                  |   76 +++
 fs/pramfs/wprotect.c                 |   41 ++
 fs/pramfs/wprotect.h                 |  151 +++++
 fs/pramfs/xattr.c                    | 1104 ++++++++++++++++++++++++++++++++++
 fs/pramfs/xattr.h                    |  131 ++++
 fs/pramfs/xattr_security.c           |   78 +++
 fs/pramfs/xattr_trusted.c            |   65 ++
 fs/pramfs/xattr_user.c               |   68 +++
 fs/pramfs/xip.c                      |   83 +++
 fs/pramfs/xip.h                      |   28 +
 include/linux/magic.h                |    1 +
 include/linux/pram_fs.h              |  130 ++++
 include/linux/pram_fs_sb.h           |   45 ++
 34 files changed, 6299 insertions(+), 3 deletions(-)


Marco 
