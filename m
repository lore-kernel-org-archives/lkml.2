Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab1EZTOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:14:24 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:58720 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758357Ab1EZTOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:14:23 -0400
X-ASG-Debug-ID: 1306437261-03d6a512a807780001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDEA689.2090004@fusionio.com>
Date: Thu, 26 May 2011 21:14:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Mike Snitzer <snitzer@redhat.com>, Mandeep Singh Baines <msb@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jrbarnette@chromium.org" <jrbarnette@chromium.org>,
        Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: dm: pass up rotational flag
References: <1306356648-30730-1-git-send-email-msb@chromium.org>	<20110526182321.GA26219@redhat.com> <yq1zkm948oa.fsf@sermon.lab.mkp.net>
X-ASG-Orig-Subj: Re: dm: pass up rotational flag
In-Reply-To: <yq1zkm948oa.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306437261
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64744
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-26 20:29, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
>>> Allow the NONROT flag to be passed through to linear mappings if all
>>> underlying device are non-rotational. Tools like ureadahead will
>>> schedule IOs differently based on the rotational flag.
> 
> Mike> Thanks for doing this, looks good in general.
> 
> I'd rather we made the rotational property part of the topology instead
> of having to special-case it in DM. I seem to recall posting a patch
> that did that at some point but I can't seem to find it...

Agree, would be a better idea.

-- 
Jens Axboe

