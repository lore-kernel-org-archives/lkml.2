Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1IBXQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:16:50 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:35554 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab1IBXQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:16:48 -0400
X-ASG-Debug-ID: 1315005407-03d6a5396973d80001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E6163DE.4030208@fusionio.com>
Date: Fri, 2 Sep 2011 17:16:46 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2 v3] Small cleanup of bdi_forker_thread()
References: <1315004059-9844-1-git-send-email-jack@suse.cz> <4E61619E.8040105@fusionio.com> <20110902231212.GH12182@quack.suse.cz>
X-ASG-Orig-Subj: Re: [PATCH 0/2 v3] Small cleanup of bdi_forker_thread()
In-Reply-To: <20110902231212.GH12182@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.101.1.21]
X-Barracuda-Start-Time: 1315005407
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.73469
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-02 17:12, Jan Kara wrote:
> On Fri 02-09-11 17:07:10, Jens Axboe wrote:
>> On 2011-09-02 16:54, Jan Kara wrote:
>>>
>>>   Hi Jens,
>>>
>>>   so after I realized how I underestimated subtlety of bdi_forker_thread()
>>> here are two small cleanups to it. The first one puts clearing of BDI_pending
>>> in a more natural place, the second patch adds a comment so that fools like
>>> me don't try to optimize the function in a wrong place...
>>
>> Thanks Jan, I've queued it up for 3.1. I've marked it as stable, looks
>> like we need it from 2.6.36 and above.
>   Thanks. But is it really a stable material? It's just a cleanup after
> all...

I guess it's not strictly stable material, since it's not fixing a
problematic issue.

-- 
Jens Axboe

