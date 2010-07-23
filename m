Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab0GWEqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:46:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42723 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab0GWEqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:46:02 -0400
Date: Fri, 23 Jul 2010 14:46:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
        <linux-cifs@vger.kernel.org>
Subject: linux-next: manual merge of the workqueues tree with the Linus'
 tree
Message-Id: <20100723144600.dd4da992.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
fs/cifs/cifsfs.c between commit 4c0c03ca54f72fdd5912516ad0a23ec5cf01bda7
("CIFS: Fix a malicious redirect problem in the DNS lookup code") from
Linus' tree and commit 9b646972467fb5fdc677f9e4251875db20bdbb64 ("cifs:
use workqueue instead of slow-work") from the workqueues tree.

I fixed it up (I think - I removed the call to cifs_exit_dns_resolver()
as there is no way to get to that code any more) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
