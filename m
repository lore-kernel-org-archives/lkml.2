Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2HYX63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 19:58:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37187 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2HYX6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 19:58:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>
References: <87lih2h6i4.fsf@xmission.com>
Date: Sat, 25 Aug 2012 16:58:14 -0700
In-Reply-To: <87lih2h6i4.fsf@xmission.com> (Eric W. Biederman's message of
	"Sat, 25 Aug 2012 16:54:59 -0700")
Message-ID: <87bohyh6cp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1974Ax//4d4aiV1NpGeXB0/OtGI41ag3Ts=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0430]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 01/15] userns: Enable building of pf_key sockets when user namespace support is enabled.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Enable building of pf_key sockets and user namespace support at the
same time.  This combination builds successfully so there is no reason
to forbid it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b445d6f..448b701 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,7 +944,6 @@ config UIDGID_CONVERTED
 	# Networking
 	depends on NET_9P = n
 	depends on AF_RXRPC = n
-	depends on NET_KEY = n
 	depends on DNS_RESOLVER = n
 
 	# Filesystems
-- 
1.7.5.4

