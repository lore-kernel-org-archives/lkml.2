Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1GZNUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:20:41 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:40481 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1GZNUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:20:34 -0400
X-ASG-Debug-ID: 1311686432-01de280c1ef11a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2EBF1D.8010409@fusionio.com>
Date: Tue, 26 Jul 2011 15:20:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
  bio_add can make use of it.
References: <CAFR8uec5MxvHEWS=hgRXo1eunjQqWrpPCVXthdGMfWR+Yitw_A@mail.gmail.com> <4E1B37B1.9030608@fusionio.com> <CAFR8ueetLzSwTEc7D1zW4Yhd8t8iFbKvjJ07onWVQJbhzSOXLQ@mail.gmail.com> <4E1B3A1D.2050400@fusionio.com> <CAFR8ued8s_V0dqxgcFfeXbzm8VrNL5eE90gqHpk-RvW8frL7QA@mail.gmail.com> <CAFR8uefgC-9stfbQCWed8j2SgHZ-Q7_dbD4iRv-Z=E91SnmmyQ@mail.gmail.com> <CAFR8uee0ixYJZe+-88fCqSSTmqCG4i9JdH3Yy2X9QpT46Q+xQg@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
  bio_add can make use of it.
In-Reply-To: <CAFR8uee0ixYJZe+-88fCqSSTmqCG4i9JdH3Yy2X9QpT46Q+xQg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311686432
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70021
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-25 19:22, Muthu Kumar wrote:
> Jens,
> Is this OK? If not, how about mpage.c fix that we discussed (since
> that is the most common case)?

Sorry, mostly away on vacation. I'll take a look at this tonight.

-- 
Jens Axboe

