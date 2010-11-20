Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab0KTKop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 05:44:45 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:41483 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0KTKon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 05:44:43 -0500
X-ASG-Debug-ID: 1290249882-6da368430001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CE7A695.10508@fusionio.com>
Date: Sat, 20 Nov 2010 11:44:37 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Miller <mike.miller@hp.com>
Subject: Re: linux-next: Tree for November 19
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>	<AANLkTik0jXvoNTfNzAGAnzDQbE5oyEVmQ0hVyYt84jGQ@mail.gmail.com> <AANLkTinUToUN8sfRBtTQm=8TeTGxDBwPnJC8j8zrJ_8c@mail.gmail.com>
X-ASG-Orig-Subj: Re: linux-next: Tree for November 19
In-Reply-To: <AANLkTinUToUN8sfRBtTQm=8TeTGxDBwPnJC8j8zrJ_8c@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1290249882
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.2209 1.0000 -0.7194
X-Barracuda-Spam-Score: -0.72
X-Barracuda-Spam-Status: No, SCORE=-0.72 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MAILTO_TO_SPAM_ADDR
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.47163
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 MAILTO_TO_SPAM_ADDR    URI: Includes a link to a likely spammer email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-20 06:52, Zimny Lech wrote:
> W dniu 20 listopada 2010 06:50 u¿ytkownik Zimny Lech
> <napohybelskurwysynom2010@gmail.com> napisa³:
>> Hi,
>>
>> 2010/11/19 Stephen Rothwell <sfr@canb.auug.org.au>:
>>> Hi all,
>>>
>>> Changes since 20101118:
>>
>> I do not recall that I saw it before
>>  CC [M]  drivers/block/cciss.o
>> /home/test/linux-2.6/drivers/block/cciss.c: In function 'cciss_cleanup':
>> /home/test/linux-2.6/drivers/block/cciss.c:4929:6: error: 'proc_cciss'
>> undeclared (first use in this function)
>> /home/test/linux-2.6/drivers/block/cciss.c:4929:6: note: each
>> undeclared identifier is reported only once for each function it
>> appears in
>> make[3]: *** [drivers/block/cciss.o] Error 1
>> make[2]: *** [drivers/block] Error 2
>> make[1]: *** [drivers] Error 2
>> make: *** [sub-make] Error 2
>>
> 
> BTW. mainline too I guess

A fix for this is queued up in for-linus, it'll go out shortly.

-- 
Jens Axboe

