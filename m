Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab1DNO5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:57:10 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:53304 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab1DNO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:57:09 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DA70B32.1090505@ise.pw.edu.pl>
Date: Thu, 14 Apr 2011 16:56:50 +0200
From: wzab <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: wzab@ise.pw.edu.pl
CC: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: Screen corrupted in Xorg with KMS on 945GM/GMS, 943/940GML chipset
 with kernel 2.6.38.2
References: <4DA4243A.5030805@ise.pw.edu.pl> <20110412184143.27dbf34f@neptune.home> <4DA4832F.2090600@ise.pw.edu.pl>
In-Reply-To: <4DA4832F.2090600@ise.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 12.04.2011 18:51, wzab pisze:
> W dniu 12.04.2011 18:41, Bruno Prémont pisze:
>> [CCing intel-gfx]
>>
>> On Tue, 12 April 2011 Wojciech Zabołotny<wzab@ise.pw.edu.pl>  wrote:
>>> After I've upgraded my kernel to 2.6.38.2, I started to experience very
>>> often screen corruption in X (it happened also earlier with 2.6.37.3,
>>> but now is very often.
>>> Hardware seems to be OK. I attach  sample screendumps, configuration of
>>> my kernel, log of the X server and output of the lspci command.
>>
>> This looks similar to the xchat corruptions I see (on i855).
>>
>> Have a look at #34980 (also 945 family) and #35460 on 
>> bugs.freedesktop.org.
>>
>> Bruno
>
> Yes, the similar symptoms have also been reported in Ubuntu
>
> https://bugs.launchpad.net/ubuntu/+source/xorg/+bug/737900
>
> I have yet another machine, with an older chipset - VGA compatible 
> controller: Intel Corporation 82865G Integrated Graphics Controller 
> (rev 02) no corruptions occur in this machine.
Ooops, sorry, today I have noticed the same problems on the machine with 
Intel Corporation 82865G Integrated Graphics Controller (rev 02).

Wojtek
