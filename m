Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab0LFGYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 01:24:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41470 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab0LFGYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 01:24:38 -0500
X-Greylist: delayed 22984 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 01:24:38 EST
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@kernel.org
References: <m1oc90n6qp.fsf@fess.ebiederm.org>
	<AANLkTikCXV_y2fmv0wTPXvxEad3Sqs_Vr4S+6_pZFDoo@mail.gmail.com>
Date: Sun, 05 Dec 2010 16:01:27 -0800
In-Reply-To: <AANLkTikCXV_y2fmv0wTPXvxEad3Sqs_Vr4S+6_pZFDoo@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 5 Dec 2010 10:06:57 -0800")
Message-ID: <m1lj43lqg8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/MZtb3iYx5gSaf1vY73GkSYPJm3M706Q8=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH]: Revert 2.6.36 chroot ttyname regression
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Dec 4, 2010 at 9:11 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> As of 2.6.36 ttyname does not work in a chroot.
>
> I'll happily revert, but even for trivial stuff like this I'd like to
> get the sign-off, just so that we always have it.

No problem, I just forgot.  The patch is resent.

Eric
