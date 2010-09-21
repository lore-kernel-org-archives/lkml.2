Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0IUTfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:35:15 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:35075 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab0IUTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:35:13 -0400
Message-ID: <4C9908D7.9030106@euromail.se>
Date: Tue, 21 Sep 2010 21:34:47 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>    <1283005748-3293-2-git-send-email-rydberg@euromail.se>    <CE1C24FC-7C9A-4940-8141-391A368C59E5@enac.fr>   <4C97BB33.5020806@euromail.se>   <6A8BB954-78BB-4507-86F3-19DA5174FA5E@enac.fr>  <4C97BE69.2030100@euromail.se>  <EBFF8B5B-5361-45B3-88B8-8254E3953578@enac.fr> <4C98ED5B.7020408@euromail.se> <83EE14B9-C3BB-43DA-AF0B-962EA40C0DB5@enac.fr>
In-Reply-To: <83EE14B9-C3BB-43DA-AF0B-962EA40C0DB5@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Oy8c5-0007tC-9K.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Oy8c5-0007tC-9K 836f357ef0f05df4463ce172d2529536
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 09:21 PM, Stéphane Chatty wrote:

> 
> Le 21 sept. 10 à 19:37, Henrik Rydberg a écrit :
> 
>> On 09/20/2010 10:23 PM, Stéphane Chatty wrote:
>>
>>>
>>> Le 20 sept. 10 à 22:04, Henrik Rydberg a écrit :
>>>>>
>>> Anyway, I have no more problem with this constant. Just with the vocabulary :-)
>>
>>
>> In the HID protocol, it is called ContactID... So, Stéphane, are we close to
>> acking this patch now? :-)
> 
> Oh yes of course, I was not clear enough in the above message. To make things
> more formal:
> 
> Acked-by: Stéphane Chatty <chaty@enac.fr>


Thanks! I will follow up with the copyright patch right away, then, and we
should be good to go.

Cheers,
Henrik
