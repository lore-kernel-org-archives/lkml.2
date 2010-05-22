Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab0EVVQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 17:16:24 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:40936 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773Ab0EVVQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 17:16:23 -0400
Message-ID: <4BF84989.3020004@euromail.se>
Date: Sat, 22 May 2010 23:15:53 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Rafi Rubin <rafi@seas.upenn.edu>, Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
References: <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com> <4BF6B673.1080507@euromail.se> <20100521165218.GA26439@core.coreip.homeip.net> <4BF6BB43.2020405@euromail.se> <20100521172222.GB26439@core.coreip.homeip.net> <4BF6C303.7030804@euromail.se> <20100521174140.GA23155@core.coreip.homeip.net> <4BF6C7B6.2020008@euromail.se> <4BF7A4E8.3050806@seas.upenn.edu> <4BF7B438.8000001@euromail.se> <20100522201637.GC30464@core.coreip.homeip.net>
In-Reply-To: <20100522201637.GC30464@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFw31-000244-Bg.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OFw31-000244-Bg 4ea6bd26111485390d7aaa8c99b70697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Sat, May 22, 2010 at 12:38:48PM +0200, Henrik Rydberg wrote:
>> Rafi Rubin wrote:
>>> On 05/21/10 13:49, Henrik Rydberg wrote:
>>>> Dmitry Torokhov wrote:
>>>>> I guess this is where our disconnect lies as when I am looking at the
>>>>> event names I view all *_MT_* events as related to the multitouch
>>>>> protocol handling.
>>>>>
>>>> Yes. It is true that slot control is MT related, but I am looking at this from
>>>> the perspective of future expansions like KEY_MT,  KEY_REL, and such, finding a
>>>> way to signal to user space which events are handled via slots. If we had
>>>> ABS_MT_SLOT, we would most likely get applications which store ABS_MT_SLOT as an
>>>> attribute of the slot together with ABS_MT_POSITION_X, ABS_MT_TOUCH_MAJOR, etc,
>>>> which is just not right. So the proposal is ABS_SLOT. May we have your verdict,
>>>> please. :-)
>>>>
>>>> Henrik
>>>>
>>> How many fingers can type on cap of a key?
>> It depends on the size of the key, does it not. :-)
>>
>> Getting serious, it is anyone's guess what will happen next, but I was picturing
>> a table, with a large multitouch screen and buttons along the side of the table.
>> Sure, we can do "ABS_BTN_0", "ABS_BTN_1", etc, but with slots in place, it seems
>> more natural to use something like "ABS_MT_BTN_X". While at it, REL_MT event
>> makes sense for those touchscreen techniques which register changes, like
>> acoustic pulse recognition.
>>
> 
> While I could see relative MT events I do not understand the need for
> slotted key events. We already allow pressing multiple keys at once and
> if a device has 2 separate keys with the same event - they either should
> be treated as one logical key or 2 separate input devices.
> 

Understood.

Henrik
