Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2KZSav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:30:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57832 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2KZSat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:30:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
References: <20121127001320.12439806f19c9b6ccce4e895@canb.auug.org.au>
Date: Mon, 26 Nov 2012 12:30:31 -0600
In-Reply-To: <20121127001320.12439806f19c9b6ccce4e895@canb.auug.org.au>
	(Stephen Rothwell's message of "Tue, 27 Nov 2012 00:13:20 +1100")
Message-ID: <87624stdx4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18tBq3FBfvueX1SBiy8uJ74Qm/T5+EC3sk=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: manual merge of the akpm tree with the userns tree
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Andrew,
>
> Today's linux-next merge of the akpm tree got a conflict in kernel/fork.c
> between commit b2e0d98705e6 ("userns: Implement unshare of the user
> namespace") from the userns tree and commit  ("fork: unshare: remove dead
> cod") from the akpm tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary (no action
> is required).

Your resolution looks correct to me.  This was just of case of two patches
changing each others context. 

Eric

