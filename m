Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0KICb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:31:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41273 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0KICb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:31:57 -0500
Date: Tue, 9 Nov 2010 13:31:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Jing Huang <huangj@brocade.com>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-Id: <20101109133155.e979a39b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/scsi/bfa/bfa_fcpim.c between commit
5fbe25c7a664601666895e8f95eaa59bd9741392 ("[SCSI] bfa: fix comments for c
files") from Linus' tree and commit
b595076a180a56d1bb170e6eceda6eb9d76f4cd3 ("tree-wide: fix comment/printk
typos") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/bfa/bfa_fcpim.c
index 135c442,aabbf3d..0000000
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@@ -2091,8 -2091,8 +2091,8 @@@ bfa_ioim_sm_cleanup_qfull(struct bfa_io
  		break;
  
  	case BFA_IOIM_SM_ABORT:
 -		/**
 +		/*
- 		 * IO is alraedy being cleaned up implicitly
+ 		 * IO is already being cleaned up implicitly
  		 */
  		ioim->io_cbfn = __bfa_cb_ioim_abort;
  		break;
