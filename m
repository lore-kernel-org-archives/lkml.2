Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2JJPbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:31:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50065 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab2JJPbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:31:01 -0400
Date: Wed, 10 Oct 2012 10:06:53 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, Kent Yoder <key@linux.vnet.ibm.com>
Message-ID: <20121010150653.GA1350@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12101015-3534-0000-0000-00000DA80631
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ecefbd94b834fa32559d854646d777c56749ef1c:

  Merge tag 'kvm-3.7-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2012-10-04 09:30:33 -0700)

are available in the git repository at:


  git://github.com/shpedoikal/linux.git tpmdd-fixes-v3.6

for you to fetch changes up to 1631cfb7cee28388b04aef6c0a73050f6fd76e4d:

  driver/char/tpm: fix regression causesd by ppi (2012-10-10 09:50:56 -0500)

----------------------------------------------------------------
Gang Wei (1):
      driver/char/tpm: fix regression causesd by ppi

 drivers/char/tpm/tpm.c     |  3 ++-
 drivers/char/tpm/tpm.h     |  9 +++++++--
 drivers/char/tpm/tpm_ppi.c | 18 ++++++++++--------
 3 files changed, 19 insertions(+), 11 deletions(-)

