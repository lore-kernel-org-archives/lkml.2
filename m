Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1KFXlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:41:01 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37666 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab1KFXk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:40:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111107095835.208466a386fbcf046c512d70@canb.auug.org.au>
Date: Sun, 06 Nov 2011 15:41:50 -0800
In-Reply-To: <20111107095835.208466a386fbcf046c512d70@canb.auug.org.au>
	(Stephen Rothwell's message of "Mon, 7 Nov 2011 09:58:35 +1100")
Message-ID: <m139e0q0n5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/uj9YN322ywo1EHKdntBtw5377QUcTGhA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: **
Subject: Re: linux-next: failing to fetch the sysctl tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> Fetching the sysctl tree produces this error:
>
> fatal: Couldn't find remote ref refs/heads/master
>
> And indeed the sysctl tree on git.kernel.org is completely empty (i.e.
> there are no commits).  Maybe you should remove it and recreate it as a
> fork of Linus' tree.

Something weird happened when I re-uploaded things.  Apparently hitting
Ctrl-C if when you are uploading and realized you forgot to clone from
Linus's repository is fatal to how git.kernel.org manages things.  Last
I checked I could not even delete the broken repository.

Can you please switch to linux/kernel/git/ebiederm/sysctl.git instead of
sysctl-2.6.git.

With a little luck I will have something interesting in there this
round.

Thanks,
Eric

