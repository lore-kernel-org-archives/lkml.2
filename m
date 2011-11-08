Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1KHAv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:51:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40241 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KHAv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:51:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111107095835.208466a386fbcf046c512d70@canb.auug.org.au>
	<m139e0q0n5.fsf@fess.ebiederm.org>
	<20111107213319.01f37a306f1c29faa386891e@canb.auug.org.au>
Date: Mon, 07 Nov 2011 16:52:17 -0800
In-Reply-To: <20111107213319.01f37a306f1c29faa386891e@canb.auug.org.au>
	(Stephen Rothwell's message of "Mon, 7 Nov 2011 21:33:19 +1100")
Message-ID: <m1pqh3o2pq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX187iKRQzVr2FpKEJiH3LomWHRE1324nPS8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
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
> On Sun, 06 Nov 2011 15:41:50 -0800 ebiederm@xmission.com (Eric W. Biederman) wrote:
>>
>> Something weird happened when I re-uploaded things.  Apparently hitting
>> Ctrl-C if when you are uploading and realized you forgot to clone from
>> Linus's repository is fatal to how git.kernel.org manages things.  Last
>> I checked I could not even delete the broken repository.
>> 
>> Can you please switch to linux/kernel/git/ebiederm/sysctl.git instead of
>> sysctl-2.6.git.
>
> Done.
>
> BTW to remove the other tree do this:
>
> ssh gitolte@ra.kernel.org unlock pub/scm/linux/kernel/git/ebiederm/sysctl-2.6
> ssh gitolte@ra.kernel.org rm pub/scm/linux/kernel/git/ebiederm/sysctl-2.6

Thanks.  unlock was apparently the gitolite magic command I did not know about.

Eric
