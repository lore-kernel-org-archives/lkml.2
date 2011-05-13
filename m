Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab1EMQgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:36:19 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:3110 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1EMQgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:36:18 -0400
Message-ID: <4DCD5DF0.8060406@atmel.com>
Date: Fri, 13 May 2011 18:36:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sshtylyov@mvista.com
Subject: Re: [PATCH V2] usb/gadget: at91sam9g20 fix end point max packet size
References: <1305042888-19401-1-git-send-email-plagnioj@jcrosoft.com>	<1305298982-5789-1-git-send-email-plagnioj@jcrosoft.com> <20110513162054.GC2728@suse.de>
In-Reply-To: <20110513162054.GC2728@suse.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/05/2011 18:20, Greg KH :
> On Fri, May 13, 2011 at 05:03:02PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> on 9g20 they are the same as the 9260
>>
>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> Resent upon Greg's request.
>> Based on current linux-next.
>> Applies cleanly on current linus' tree (2.6.39-rc7+)
>>
>> BTW, can we imagine it going to mainline before .39-final in a "fixes" pull
>> request to Linus from a at91 tree?
> 
> No, as I don't think this is a bug-fix-only-for-regression, is it?

Not a regression, but a
oh-my-god-how-it-has-been-there-for-such-a-long-time type of bug.

> It looks to be a "fix for new hardware" type thing, right?

Hardware has been merged in kernel for a pretty long time now... But
anyway, I fully understand: this bug has been sitting in the dark for a
handful of kernel revision now, so it can wait for .40...

> And is this really the correct way to do this for the .40 kernel, which
> is where I would be queueing this up for?

Right. Let's queue it for .40.

Bye,
-- 
Nicolas Ferre

