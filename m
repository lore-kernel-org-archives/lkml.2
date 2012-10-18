Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2JRMLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:11:24 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:46522 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2JRMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:11:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        dhowells@redhat.com, manfred@colorfullife.com, hughd@google.com,
        jmorris@namei.org, mtk.manpages@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, paulmck@linux.vnet.ibm.com,
        sds@tycho.nsa.gov, devel@openvz.org, a.p.zijlstra@chello.nl,
        cmetcalf@tilera.com, linux-driver@qlogic.com, ron.mercer@qlogic.com,
        viro@zeniv.linux.org.uk, eparis@parisplace.org, tglx@linutronix.de,
        jitendra.kalsaria@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        casey@schaufler-ca.com,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
References: <20121018101543.16036.12221.stgit@localhost.localdomain>
Date: Thu, 18 Oct 2012 05:11:08 -0700
In-Reply-To: <20121018101543.16036.12221.stgit@localhost.localdomain>
	(Stanislav Kinsbursky's message of "Thu, 18 Oct 2012 14:22:21 +0400")
Message-ID: <87a9vk3rqb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18gjjTAaEtlbtyy8REANiH3CvG8dpdoTgg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v7 00/10] IPC: checkpoint/restore in userspace enhancements
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

You ignored all of my feedback that the first 7 messages of your
patchset are unnecessary.  In particular you did not attempt to focus
your patchset on those operations that are most important.

Upon examination it appears also that the 8th and 9th patches of the
patchset are also unnecessary.  And the 10th patch is just a test of the
previous patches, making the 10th patch unneceesary without the rest.

In net this entire patchset is unnecessary and a waste of your reviewers
time.

Once you have IPC checkpoint and restore working there may be a point to
come back and optimize things.  Please don't come back with any System V
Interprocess Communication patches until you can report how much time
is saved by each and every change.

Eric

