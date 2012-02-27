Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2B0K0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:26:39 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:48245 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2B0K0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:26:37 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1257)
Subject: [git pull] Trivial NTFS and LDM changes.
From: Anton Altaparmakov <aia21@cam.ac.uk>
Date: Mon, 27 Feb 2012 10:26:35 +0000
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ntfs-dev <linux-ntfs-dev@lists.sourceforge.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <6BDEC6CA-36B6-4CA7-88C3-02FD1A0B2526@cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some trivial NTFS changes (a spelling fix and two use before NULL check cases found by Coverity as well as an update in MAINTAINERS for the path to the ntfs git repo) together with a simple LDM fix for parsing fragmented VBLKs.

Please pull from

                git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs.git

to get these changes:

 MAINTAINERS            |    2 +-
 block/partitions/ldm.c |   11 ++++-------
 fs/ntfs/attrib.c       |    6 +++---
 fs/ntfs/mft.c          |    6 +++---
 fs/ntfs/super.c        |    4 +---
 5 files changed, 12 insertions(+), 17 deletions(-)

Thanks a lot in advance!

PS. None of this is especially urgent so if you prefer me to re-send when the next merge window opens please let me know.  I just thought these things are so trivial we might as well get them in now.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

