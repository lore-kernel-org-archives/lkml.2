Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1CTKpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 06:45:33 -0400
Received: from nm2-vm0.bullet.mail.in.yahoo.com ([121.101.151.210]:44092 "HELO
	nm2-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751708Ab1CTKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 06:45:31 -0400
X-Yahoo-Newman-Id: 435704.47946.bm@omp1004.mail.in.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=5rJSmS15hCmGGnBm75lbozmsl+zOxrm0sLKzLzAX2/rTgMcqO7D/CGA6xJiYydKK63yZ1jdwotzl0Nb74yYcZUiEiqHqgtsT1arNWWJNNnrXb9UNHiVTsJieyuH4IG8fys0VwHMs0KCykx6erH0dYNV9iy5TMpCPwvBMBW1GHAU=  ;
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
X-YMail-OSG: AglwZw4VM1lCNllSmUltEWLQ7pztrVVF1a0aJ.e34ZCTxjp
 ysofmgCInp7z4zbixJ9qkefV0AaLIBRrZj8gRz4sXEuTi7SFUVNEjOUOZKPf
 44hlUMUkcHh.f0KzwFBBB6Uc8ZZZ5eUIEjIqOeZsighnfwuftkm_jmOZOG.9
 n70nyG7jfsa3tLWJlOR2T.V2Y9UXFlYdNwWbmnQP_6C5xsU6gH_XpT8gjI72
 QI7vm1knPdD_HVbogxhkurw0APj75l9ripMpPYtJFw7apZlSZX9QzYJSFAX5
 jI8fzw6SDDA--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 20 Mar 2011 16:15:27 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: format fixes
Message-ID: <20110320104527.GA3120@debian.Jeff>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello ,

I have created a patch with fixes and format
error by replacing spaces with tabs.

I have attached the patch along with this mail.

/Thanks

-- 
software engineer.
department of computer science
rajagiri school of engineering and technology.

--82I3+IH0IqGh5yIs
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Fixed-format-issue-by-replacing-spaces-with-tabs.patch"

>From e60771bb9c855231773f741c48d76d26fcda893f Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Sun, 20 Mar 2011 16:03:37 +0530
Subject: [PATCH] Fixed format issue by replacing spaces with tabs.

This is a patch to the samsung-laptop.c file
in staging section under drivers that fixes
up format issue by replacing spaces with tabs
Author : Jeffrin Jose
Signed-off-by: Jeffrin Jose
---
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 6607a89..ca27aec 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -261,7 +261,7 @@ static int sabi_get_command(u8 command, struct sabi_retval *sretval)
 	iface_data = readb(sabi_iface + SABI_IFACE_DATA);
 	if (complete != 0xaa || iface_data == 0xff) {
 		pr_warn("SABI get command 0x%02x failed with completion flag 0x%02x and data 0x%02x\n",
-		        command, complete, iface_data);
+			command, complete, iface_data);
 		retval = -EINVAL;
 		goto exit;
 	}
-- 
1.7.1


--82I3+IH0IqGh5yIs--
