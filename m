Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0DTXw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:52:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46370 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0DTXw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:52:56 -0400
Message-ID: <4BCE3D88.4010502@zytor.com>
Date: Tue, 20 Apr 2010 16:49:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [patch] vt: deactive Shift In/Out in unicode mode
References: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr> <20100419153136.3585281f@lxorguk.ukuu.org.uk> <alpine.LSU.2.01.1004191812570.25222@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1004191812570.25222@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 09:20 AM, Jan Engelhardt wrote:
> 
> On Monday 2010-04-19 16:31, Alan Cox wrote:
>>>
>>> I am proposing the patch below for inclusion.
>>> Also pullable via
>>> 	git://dev.medozas.de/linux siso
>>
>> It seems to do a lot of other things as well. Can you split out just the
>> relevant bit ?
> 
> It's really just the top commit. Perhaps I should rebase it to a
> v2.6.34-rcX tag so that shortlog does what one expects.
> 
> Alexander mentioned:
> 
> [quoting the gmane nntp posting which was stripped of To:s and Cc:s]
>>
>> Since KOI7 is not used by any glibc locale, your use case is now 
>> extinct. I think that, unless someone finds out a different use case, 
>> these SI and SO characters should be deactivated completely (and not 
>> just in unicode mode).
> 
> Alan, do you agree that the entire SI/SO can/should be removed?

VT line drawing characters are generally assumed to be accessible using
SI/SO (as they are by default.)

	-hpa
