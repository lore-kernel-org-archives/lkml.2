Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab0CUPkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 11:40:43 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:59211 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0CUPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 11:40:42 -0400
X-SENDER-IP: [83.226.249.129]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjozAHTapUtT4vmBPGdsb2JhbACBO4QslV8BAQEBN7hOhH0E
X-IronPort-AV: E=Sophos;i="4.51,283,1267398000"; 
   d="scan'208";a="53774489"
Message-ID: <4BA63DFD.4010803@coyote.org>
Date: Sun, 21 Mar 2010 16:40:45 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Pavel Machek <pavel@ucw.cz>, Dan Carpenter <error27@gmail.com>,
       gregkh@suse.de, greg@kroah.com, harvey.harrison@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: reg.c Coding style fixes.
References: <1269098051-6594-1-git-send-email-lindley@coyote.org> <20100320162426.GB28881@bicker> <4BA5204C.9050208@coyote.org> <20100321065814.GB11917@elf.ucw.cz> <4BA61384.3030005@cs.helsinki.fi>
In-Reply-To: <4BA61384.3030005@cs.helsinki.fi>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka

I will check them more in the future.
I will come back with a new patch against master that combines the two commits
as soon as I get my head around how to get git to combine them.. :)
(And paint the little room in the appartment.. :)

/Lars

On 2010-03-21 13:39, Pekka Enberg wrote:
> Pavel Machek wrote:
>>> [PATCH] staging: winbond: reg.c Fix accidental commenting of msleep(10)
>>>
>>> I accidentaly commented out msleep() in one place.
>>> This applies after previous patch:
>>> Message-Id: <1269098051-6594-1-git-send-email-lindley@coyote.org>
>>>
>>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>>
>> Ack. but you probably want to merge those two pieces together.
> 
> Yes. Like I said before, please _check_ the result before posting your
> patches. It's very easy to make silly mistakes in "trivial" patches like
> these. Remember, it's not about quantity, it's about quality of each
> individual patch no matter how trivial they might seem at first.
> 
>             Pekka
> 
