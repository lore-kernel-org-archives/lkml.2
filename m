Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab2ESVwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 17:52:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33252 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab2ESVw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 17:52:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120516195513.29d921bc25f308f92f0d6471@canb.auug.org.au>
Date: Sat, 19 May 2012 15:52:18 -0600
In-Reply-To: <20120516195513.29d921bc25f308f92f0d6471@canb.auug.org.au>
	(Stephen Rothwell's message of "Wed, 16 May 2012 19:55:13 +1000")
Message-ID: <87d35z260d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=70.65.177.2;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19RKSUtsUnKjjiBTHSO5Vl0Mcu5DutuDJc=
X-SA-Exim-Connect-IP: 70.65.177.2
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0659]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: build warning after merge of the final tree (userns tree related)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) produced this warning:
>
> kernel/user.c:30:4: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]
> kernel/user.c:38:4: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]
>
> Introduced by commit 22d917d80e84 ("userns: Rework the user_namespace
> adding uid/gid mapping support").

Ugh.  I missed this email the first time through.  Thank you for the
report this problem should be fixed now.

Eric

