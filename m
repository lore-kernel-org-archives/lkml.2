Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0E3PJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:09:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34353 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0E3PJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:09:11 -0400
To: David Miller <davem@davemloft.net>
Cc: amwang@redhat.com, hooanon05@yahoo.co.jp, opurdila@ixiacom.com,
       linux-kernel@vger.kernel.org
References: <4BFB6197.5030206@redhat.com>
	<1274770184-12611-1-git-send-email-hooanon05@yahoo.co.jp>
	<4BFBC153.9040704@redhat.com>
	<20100525.161040.71125311.davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 30 May 2010 08:09:02 -0700
In-Reply-To: <20100525.161040.71125311.davem@davemloft.net> (David Miller's message of "Tue\, 25 May 2010 16\:10\:40 -0700 \(PDT\)")
Message-ID: <m1k4qlh1f5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: davem@davemloft.net, linux-kernel@vger.kernel.org, opurdila@ixiacom.com, hooanon05@yahoo.co.jp, amwang@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] proc_dointvec, write a single value
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Cong Wang <amwang@redhat.com>
> Date: Tue, 25 May 2010 20:23:47 +0800
>
>> On 05/25/10 14:49, J. R. Okajima wrote:
>>> The commit 00b7c3395aec3df43de5bd02a3c5a099ca51169f
>>> "sysctl: refactor integer handling proc code"
>>> modified the behaviour of writing to /proc.
>>> Before the commit, write("1\n") to /proc/sys/kernel/printk
>>> succeeded. But
>>> now it returns EINVAL.
>>>
>>> This commit supports writing a single value to a multi-valued entry.
>>>
>>> Signed-off-by: J. R. Okajima<hooanon05@yahoo.co.jp>
>> 
>> Reviewed-and-tested-by: WANG Cong <amwang@redhat.com>
>
> Since the regression causing change came in via the net tree
> I'll integrate this fix too, applied, thanks!

Thanks, guys for fixing this.

I hate to see my review comments show up like this in practice.
I had really hoped those unnecessary changes to proc would have
been dropped from that patchset.  Oh well.

Eric
