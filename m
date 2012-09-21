Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2IUHLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:11:51 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:49307 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2IUHLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:11:49 -0400
X-ASG-Debug-ID: 1348211508-0421b562ec4ada0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <505C1331.8050907@fusionio.com>
Date: Fri, 21 Sep 2012 09:11:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 01/14] userns: Convert loop to use kuid_t instead of uid_t
References: <87k3vote43.fsf@xmission.com> <1348187330-6616-1-git-send-email-ebiederm@xmission.com> <505C0438.9060907@fusionio.com> <87sjabsvkx.fsf@xmission.com>
X-ASG-Orig-Subj: Re: [PATCH 01/14] userns: Convert loop to use kuid_t instead of uid_t
In-Reply-To: <87sjabsvkx.fsf@xmission.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1348211508
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.109148
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-21 09:07, Eric W. Biederman wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
>> On 2012-09-21 02:28, Eric W. Biederman wrote:
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>
>>> Cc: Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>>> ---
>>>  drivers/block/loop.c |    4 ++--
>>>  include/linux/loop.h |    2 +-
>>>  init/Kconfig         |    1 -
>>>  3 files changed, 3 insertions(+), 4 deletions(-)
>>
>> Thanks Eric, queued for 3.7.
> 
> Would it be a problem if I also merged throug my user-namespace.git tree?
> 
> That was the original plan and it is handy to keep all of the patches
> together.
> 
> Not that it matters much in this case.

Not at all, go ahead. It'll be trivial to resolve any merge conflict due
to this.

BTW, this:

Cc: Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

in your original patch needs fixing up. I'm assuming it's a copy-paste
error and meant to be a Cc, since I haven't signed-off on it.

-- 
Jens Axboe

