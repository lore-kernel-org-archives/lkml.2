Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab1CBDyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:54:06 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:42910 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757767Ab1CBDyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:54:04 -0500
Message-ID: <4D6DBF59.2050005@bluewatersys.com>
Date: Wed, 02 Mar 2011 16:54:01 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: ext Nishanth Menon <nm@ti.com>, ext Tony Lindgren <tony@atomide.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        Ambresh <a0393775@ti.com>, Andrei Warkentin <andreiw@motorola.com>,
        Lee Jones <Lee.Jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        David Brown <davidb@codeaurora.org>,
        Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>,
        linux-arm-msm@vger.kernel.org, loic.pallardy@stericsson.com,
        "eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jouni Hogander <jouni.hogander@nokia.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>	<AANLkTin7vRMreG3hOAk95MYZUCV-Kr6ac7gD7jgvX6Gf@mail.gmail.com>	<20110216115729.GA29817@besouro.research.nokia.com>	<4D6B78BF.1020102@stericsson.com>	<4D6C7B56.9060109@codeaurora.org>	<AANLkTikvhj49DftS9c_NouASY9_MbYPCfmSUdJg6pf-5@mail.gmail.com>	<4D6D9B10.9000606@codeaurora.org>	<4D6D9D06.2020204@bluewatersys.com>	<4D6D9FC7.1090206@codeaurora.org>	<4D6DA290.2010607@bluewatersys.com>	<4D6DAA24.3000204@codeaurora.org>	<4D6DAE6E.4030701@bluewatersys.com>	<4D6DB1B1.4060908@codeaurora.org>	<4D6DB566.4090908@bluewatersys.com>	<4D6DB7CB.7070701@codeaurora.org> <4D6DBAED.7070805@bluewatersys.com> <4D6DBD8C.70904@codeaurora.org>
In-Reply-To: <4D6DBD8C.70904@codeaurora.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 04:46 PM, Saravana Kannan wrote:
> On 03/01/2011 07:35 PM, Ryan Mallon wrote:
>> On 03/02/2011 04:21 PM, Saravana Kannan wrote:
>>> On 03/01/2011 07:11 PM, Ryan Mallon wrote:
>>>> On 03/02/2011 03:55 PM, Saravana Kannan wrote:
>>>>> On 03/01/2011 06:41 PM, Ryan Mallon wrote:
>>>>>> On 03/02/2011 03:23 PM, Saravana Kannan wrote:

<snip>

>> The only real objection I have to adding the SoC family information is
>> basically to discourage it being abused by userspace. I can see it being
>> useful in debug situations, but I can also see stupid userspace
>> applications explicitly testing for some particular SoC, rather than
>> more correctly (IMHO) checking for presence of certain drivers etc.
> 
> True, but so many other things could be misused by stupid userspace
> programs. When there are legitimate usecases, I think we shouldn't
> prevent them just because we think a stupid userspace program could
> misuse it.
> 
> Again, although you might not be gung-ho about this, I think I have at
> least made you indifferent/mildly supportive to adding socinfo. If you
> don't mind, I would like to wait for others to chime in before
> continuing this discussion.

Agreed.

In general I am in support of having the SoC information exposed
somewhere. I think we just want to be careful that it doesn't become a
dumping ground for anything and everything SoC related whether the
information is useful or not. I think each piece of exposed information
should have a genuine use case, not just "because we can".

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
