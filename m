Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2LNWFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:05:16 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:49238 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2LNWFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:05:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
References: <87txroxpgq.fsf@xmission.com>
Date: Fri, 14 Dec 2012 14:05:04 -0800
In-Reply-To: <87txroxpgq.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 14 Dec 2012 14:01:57 -0800")
Message-ID: <876244xpbj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19h9Mf2wSbQcDGORBWe3v9jNskm8hgDyvM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 4/4] userns: Fix typo in description of the limitation of userns_install
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index f5975cc..2b042c4 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -799,7 +799,7 @@ static int userns_install(struct nsproxy *nsproxy, void *ns)
 	if (user_ns == current_user_ns())
 		return -EINVAL;
 
-	/* Threaded many not enter a different user namespace */
+	/* Threaded processes may not enter a different user namespace */
 	if (atomic_read(&current->mm->mm_users) > 1)
 		return -EINVAL;
 
-- 
1.7.5.4

