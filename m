Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2DHMnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 08:43:00 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2404 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab2DHMmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 08:42:43 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4F8187B0.1000804@broadcom.com>
Date: Sun, 8 Apr 2012 14:42:24 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keith Packard" <keithp@keithp.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Stephen Hemminger" <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
 <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
 <CAB=NE6Uf2cvhLcS4+Nu4j0DvorOZJJR1pWOKteTbQuHan07nng@mail.gmail.com>
In-Reply-To: <CAB=NE6Uf2cvhLcS4+Nu4j0DvorOZJJR1pWOKteTbQuHan07nng@mail.gmail.com>
X-WSS-ID: 639F55953IO2136363-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 03:02 AM, Luis R. Rodriguez wrote:
> On Fri, Apr 6, 2012 at 5:51 PM, Luis R. Rodriguez<mcgrof@frijolero.org>  wrote:
>
>> 4) Use the patch and leave it to the person who wants to extract code
>> to figure out the exact module license.
>
> After some though I think this is the only approach possible. Consider
> ath5k which has files under difference licenses:
>
>    * Dual BSD/GPL
>    * GPL
>    * ISC
>
> The person taking code must check the header of each file.
>
>    Luis

I would say that regardless your patch the "your preferred adjective" 
license disclaimer in the source files trumps any MODULE_LICENSE value 
so checking the files is always a necessary step. It is the only place 
to look for the specific license information and it is on a per-file 
basis as stated above. MODULE_LICENSE clearly groups these so a 
generalization seems justified just for that.

So MODULE_LICENSE is really just about allowing EXPORT_SYMBOL_GPL or 
not. I admit that statement does not cover everything as the 
MODULE_LICENSE is part of the module information, but as said it may or 
may not cover a number of different licenses used within the module.

So this specific macro does not, or even should not, help people figure 
out the license. We could consider some other tagging of each and every 
source file and add some scripting support to do the task, but that will 
be one hell of a patch so I will forever deny suggesting it ;-)

Gr. AvS

