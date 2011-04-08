Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1DHPGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:06:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60772 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1DHPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oqqxOxmdPdEKDOoBUotQ4bN9dSeCnlLY6OM3Lwfg06TFkHO6/X2EISGHWLQ8/kyLrQ
         3oU0aJA8uOMLpjdAqDscD6X/1uEdQeB0Qfi/FYD2W/a1LTXpjyGzKbMkVFOMfLPpX9v9
         3s29TpYeg10gEka702odB02Hw7Q7SVPn4wCHE=
Message-ID: <4D9F246F.2030305@gmail.com>
Date: Fri, 08 Apr 2011 08:06:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ricard Wanderlof <ricard.wanderlof@axis.com>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
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
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com> <20110407200541.GC8569@pengutronix.de> <4D9E4A59.8010604@gmail.com> <Pine.LNX.4.64.1104080909040.5186@lnxricardw.se.axis.com>
In-Reply-To: <Pine.LNX.4.64.1104080909040.5186@lnxricardw.se.axis.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 12:14 AM, Ricard Wanderlof wrote:
>
> On Fri, 8 Apr 2011, Justin P. Mattock wrote:
>
>> On 04/07/2011 01:05 PM, Uwe Kleine-König wrote:
>>> On Thu, Apr 07, 2011 at 09:09:22AM -0700, Justin P. Mattock wrote:
>>>> The patch below fixes some typos "recieve" in various parts of the
>>>> kernel.
>>>> Note: these below are in actual code rather than comments(excpet for
>>>> r852.c which
>>> s/excpet/except/
>>>
>>>> has a code fix, and comment).
>>>> compile tested as best as I can...
>>> I'm not a native speaker, but "as good as" sounds better in my ears.
>>>
>>> Best regards
>>> Uwe
>>>
>>
>> your right.. gcc and friends are the one's doing all the reall work:
>> "as good as *"
>
> I think Uwe was thinking of grammar rather than who was doing the actual
> work.
>
> Now that I've gone more or less off topic I may as well voice my opinion
> the 'as best as I can' sounds like a mixup of two constructs: either 'as
> best I can' (which is probably slightly unusual these days), or 'as well
> as I can'. 'I've done it as good as I can' is gramatically wrong (since
> 'good' is an adjective and 'well' is an adverb, and it is referring to
> 'how I did it' (or in the case above, 'how well I tested it'), but
> fairly common nevertheless, and given the large percentage of non-native
> speakers in the Linux community I wouldn't worry about it, the meaning
> is clear anyway.
>
> I'll shut up and go now. :-)
>
> /Ricard


well... pretty good explanation.

Justin P. Mattock
