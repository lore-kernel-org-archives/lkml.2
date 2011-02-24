Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1BXNtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:49:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:43972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1BXNta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:49:30 -0500
Message-ID: <4D6661E4.6040505@infradead.org>
Date: Thu, 24 Feb 2011 10:49:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [PATCH 1/1] DVB-USB: dib0700, fix oops with non-dib7000pc devices
References: <1296930047-22689-1-git-send-email-jslaby@suse.cz> <4D664DE5.7020002@gmail.com> <4D6654B2.1080707@infradead.org> <4D665FFF.7050501@suse.cz>
In-Reply-To: <4D665FFF.7050501@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-02-2011 10:41, Jiri Slaby escreveu:
> On 02/24/2011 01:53 PM, Mauro Carvalho Chehab wrote:
>> Em 24-02-2011 09:24, Jiri Slaby escreveu:
>>> Hmm, could anybody pick it up?
>>>
>>> On 02/05/2011 07:20 PM, Jiri Slaby wrote:
>>>> These devices use different internal structures (dib7000m) and
>>>> dib7000p pid ctrl accesses invalid members causing kernel to die.
>>>>
>>>> Introduce pid control functions for dib7000m which operate on the
>>>> correct structure.
>>
>> Patrick (DibCom drivers maintainer) has proposed an alternate patch for it [1]
>> that properly address the issues:
>>
>> http://git.linuxtv.org/pb/media_tree.git?a=commitdiff;h=80a5f1fdc6beb496347cbb297f9c1458c8cb9f50
>>
>> [1] http://www.spinics.net/lists/linux-media/msg27890.html
>>
>> Could you please test it?
> 
> Yes, I will later.
> 
> Is there any reason why this is not in Linus' and stable trees and
> mainly in linux/next already?

Yes. I'm waiting for confirmation that this patch fixes the reported issue.

Cheers,
Mauro
