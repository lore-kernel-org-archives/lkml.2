Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2IUHHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:07:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42472 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2IUHHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:07:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-security-module\@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <87k3vote43.fsf@xmission.com>
	<1348187330-6616-1-git-send-email-ebiederm@xmission.com>
	<505C0438.9060907@fusionio.com>
Date: Fri, 21 Sep 2012 00:07:10 -0700
In-Reply-To: <505C0438.9060907@fusionio.com> (Jens Axboe's message of "Fri, 21
	Sep 2012 08:07:52 +0200")
Message-ID: <87sjabsvkx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/SECikYNvc9B/mA82WrHAVTNV2tbtv/+A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jens Axboe <jaxboe@fusionio.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 01/14] userns: Convert loop to use kuid_t instead of uid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

> On 2012-09-21 02:28, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Cc: Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  drivers/block/loop.c |    4 ++--
>>  include/linux/loop.h |    2 +-
>>  init/Kconfig         |    1 -
>>  3 files changed, 3 insertions(+), 4 deletions(-)
>
> Thanks Eric, queued for 3.7.

Would it be a problem if I also merged throug my user-namespace.git tree?

That was the original plan and it is handy to keep all of the patches
together.

Not that it matters much in this case.

Eric



