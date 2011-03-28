Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1C1HVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:21:49 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:46222 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1C1HVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:21:47 -0400
X-ASG-Debug-ID: 1301296906-01de284cf8c6e50001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D903708.1070800@fusionio.com>
Date: Mon, 28 Mar 2011 09:21:44 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
References: <4D8E36CC.7080707@fusionio.com>	<20110328042311.GA15481@elte.hu>	<AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com>	<20110328160812.b4d19eb5.sfr@canb.auug.org.au>	<4D902E2C.2010701@fusionio.com> <20110328180434.d24e4465.sfr@canb.auug.org.au>
X-ASG-Orig-Subj: Re: [GIT PULL] block drivers for 2.6.39-rc
In-Reply-To: <20110328180434.d24e4465.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301296906
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59192
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-28 09:04, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Mon, 28 Mar 2011 08:43:56 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Yes, and I merged your patch to fixup the build (on PPC, as I recall).
> 
> That was an earlier build problem.

Seems I missed the last iteration of this.

-- 
Jens Axboe

