Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967242Ab2EPBMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:12:41 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60773 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966274Ab2EPBMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:12:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120514191337.e06ca84184b73b20b5c52689@canb.auug.org.au>
Date: Tue, 15 May 2012 18:12:19 -0700
In-Reply-To: <20120514191337.e06ca84184b73b20b5c52689@canb.auug.org.au>
	(Stephen Rothwell's message of "Mon, 14 May 2012 19:13:37 +1000")
Message-ID: <87fwb12aks.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=70.65.242.55;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19yMqO6h2JNeEcXifUJOgagrlg8umFWRIs=
X-SA-Exim-Connect-IP: 70.65.242.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: build failure after merge of the userns tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> After merging the userns tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/stat.c: In function 'cp_new_stat64':
> fs/stat.c:354:61: error: expected ';' before ')' token
> fs/stat.c:354:61: error: expected statement before ')' token
> fs/stat.c:355:61: error: expected ';' before ')' token
> fs/stat.c:355:61: error: expected statement before ')' token
>
> I have dropped the userns tree for today.

*puts paper bag on head*

Thanks, and fixed.

Eric
