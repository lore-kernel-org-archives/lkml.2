Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab1EYMmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:42:53 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:45695 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589Ab1EYMmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:42:52 -0400
X-ASG-Debug-ID: 1306327371-03d6a50f5825c20001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDCF947.2020505@fusionio.com>
Date: Wed, 25 May 2011 14:42:47 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: SLUB regression in current Linus
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org> <20110525074040.GA9233@elte.hu>
X-ASG-Orig-Subj: Re: SLUB regression in current Linus
In-Reply-To: <20110525074040.GA9233@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306327371
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 09:40, Ingo Molnar wrote:
> 
> * James Morris <jmorris@namei.org> wrote:
> 
>> I started experiencing a boot hang in 2.6.39+, and bisected it to this 
>> change:
> 
> i too was seeing various instabilities and SLUB corruption in -tip testing. 
> Every 5th randconfig kernel crashes.
> 
> I started testing the revert.

My test machine insta-crashes on boot. Lets please get this reverted.

-- 
Jens Axboe

