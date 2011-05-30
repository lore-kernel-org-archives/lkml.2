Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1E3F0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:26:50 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:37752 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab1E3F0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:26:49 -0400
X-ASG-Debug-ID: 1306733208-03d6a512a81c4c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE32A95.6090203@fusionio.com>
Date: Mon, 30 May 2011 07:26:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Follow up block fixes
References: <4DDFA2B6.3000404@fusionio.com> <1306723859.6368.1.camel@edumazet-laptop>
X-ASG-Orig-Subj: Re: [GIT PULL] Follow up block fixes
In-Reply-To: <1306723859.6368.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306733208
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65074
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-30 04:50, Eric Dumazet wrote:
> Le vendredi 27 mai 2011 à 15:10 +0200, Jens Axboe a écrit :
>> Hi Linus,
>>
>> Mainly pushing this a bit early to resolve an oops that has been
>> reported by Eric Dumazet. 
> 
> Hi Jens
> 
> 3.0.0-rc1 on another machine gives similar problem, but at least machine
> survives.

This is crap, I'm reverting the damn change. Really not worth the
bother.

-- 
Jens Axboe

