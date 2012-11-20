Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2KTMrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:47:06 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51205 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2KTMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:47:02 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 20 Nov 2012 04:43:40 -0800
Message-Id: <1353415420-5457-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19GhfApLgxQnQsiV0O2olsyXXTuZ959HqM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0023]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH RFC 12/12] userns: Remove the EXPERMINTAL kconfig tag
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

While there is more work to be done in the form of allowing
more to happen when you have root inside of a user namespace
there is nothing experimental about them.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 init/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6c93bd8..cfd2789 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -961,8 +961,7 @@ config IPC_NS
 	  different IPC objects in different namespaces.
 
 config USER_NS
-	bool "User namespace (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "User namespace"
 	default n
 	help
 	  This allows containers, i.e. vservers, to use user namespaces
-- 
1.7.5.4

