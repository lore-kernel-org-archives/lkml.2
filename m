Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1DHHOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:14:08 -0400
Received: from ra.se.axis.com ([195.60.68.13]:49395 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab1DHHOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:14:07 -0400
Date: Fri, 8 Apr 2011 09:14:04 +0200 (CEST)
From: Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw.se.axis.com
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "socketcan-core@lists.berlios.de" <socketcan-core@lists.berlios.de>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 1/6]Fix typo "recieve" in various parts of the kernel.
In-Reply-To: <4D9E4A59.8010604@gmail.com>
Message-ID: <Pine.LNX.4.64.1104080909040.5186@lnxricardw.se.axis.com>
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com>
 <20110407200541.GC8569@pengutronix.de> <4D9E4A59.8010604@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 Apr 2011, Justin P. Mattock wrote:

> On 04/07/2011 01:05 PM, Uwe Kleine-König wrote:
>> On Thu, Apr 07, 2011 at 09:09:22AM -0700, Justin P. Mattock wrote:
>>> The patch below fixes some typos "recieve" in various parts of the kernel.
>>> Note: these below are in actual code rather than comments(excpet for r852.c which
>> s/excpet/except/
>>
>>> has a code fix, and comment).
>>> compile tested as best as I can...
>> I'm not a native speaker, but "as good as" sounds better in my ears.
>>
>> Best regards
>> Uwe
>>
>
> your right.. gcc and friends are the one's doing all the reall work: "as 
> good as *"

I think Uwe was thinking of grammar rather than who was doing the actual 
work.

Now that I've gone more or less off topic I may as well voice my opinion 
the 'as best as I can' sounds like a mixup of two constructs: either 'as 
best I can' (which is probably slightly unusual these days), or 'as well 
as I can'. 'I've done it as good as I can' is gramatically wrong (since 
'good' is an adjective and 'well' is an adverb, and it is referring to 
'how I did it' (or in the case above, 'how well I tested it'), but fairly 
common nevertheless, and given the large percentage of non-native speakers 
in the Linux community I wouldn't worry about it, the meaning is clear 
anyway.

I'll shut up and go now. :-)

/Ricard
-- 
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
