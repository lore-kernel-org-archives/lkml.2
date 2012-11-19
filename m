Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2KSOVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:21:52 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35277 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2KSOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:21:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1353321882-30491-1-git-send-email-gaofeng@cn.fujitsu.com>
	<20121119141224.GA4321@mail.hallyn.com>
Date: Mon, 19 Nov 2012 06:21:32 -0800
In-Reply-To: <20121119141224.GA4321@mail.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 19 Nov 2012 14:12:24 +0000")
Message-ID: <87obitad1v.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18K9oXmcVtV9IGCj4enYk2J71wOkbTNdfg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] pidns: remove the useless function is_container_init
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Gao feng (gaofeng@cn.fujitsu.com):
>> since commit 1cdcbec1a3372c0c49c59d292e708fd07b509f18,
>> is_container_init has no used for a long time.
>> 
>> just remove it.
>
> Only thing is it's being exported, so I think it needs to go through
> deprecation.

Exports do not create an ABI.  No internal kernel users are enough.

Eric
