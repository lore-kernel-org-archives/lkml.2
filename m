Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0IURiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:38:19 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:55751 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab0IURiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:38:18 -0400
Message-ID: <4C98ED5B.7020408@euromail.se>
Date: Tue, 21 Sep 2010 19:37:31 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>   <1283005748-3293-2-git-send-email-rydberg@euromail.se>   <CE1C24FC-7C9A-4940-8141-391A368C59E5@enac.fr>  <4C97BB33.5020806@euromail.se>  <6A8BB954-78BB-4507-86F3-19DA5174FA5E@enac.fr> <4C97BE69.2030100@euromail.se> <EBFF8B5B-5361-45B3-88B8-8254E3953578@enac.fr>
In-Reply-To: <EBFF8B5B-5361-45B3-88B8-8254E3953578@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Oy6mc-0000ZB-CR.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Oy6mc-0000ZB-CR d15e21db6116eb425e955c15796c68da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 10:23 PM, Stéphane Chatty wrote:

> 
> Le 20 sept. 10 à 22:04, Henrik Rydberg a écrit :
>>>
>>> What about this:
>>> +            value = clamp_val(value, 0, MAX_SLOTS - 1);
>>>              if (md->valid) {
>>>                  md->curid = value;
>>>                  md->f[value].touch = md->touch;
>>>
>>> If you had tracking IDs 59, 60 and 61 in the same frame, this would not work
>>> properly would it?
>>
>>
>> That is the slot id being set. The microtouch controller is also using slots
>> internally.
>>
> 
> Oh, right. Once again back to your definition of tracking ID that is not so
> intuitive to me :-) In the end we might end up dealing with three IDs: the
> device's tracking ID, the slot ID, and the Linux tracking ID. Here, the first
> and the second are the same but will they always be? I remember when Stantum
> used to provide us with 16 bit "device tracking IDs"...
> 
> Anyway, I have no more problem with this constant. Just with the vocabulary :-)


In the HID protocol, it is called ContactID... So, Stéphane, are we close to
acking this patch now? :-)

Cheers,
Henrik
