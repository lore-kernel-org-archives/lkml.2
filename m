Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab0LNJKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:10:50 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:49867 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842Ab0LNJKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:10:47 -0500
Message-ID: <4D073472.10104@euromail.se>
Date: Tue, 14 Dec 2010 10:10:10 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se> <4D065BDE.5020107@canonical.com> <4D068E3C.8080100@euromail.se> <4D06A60D.7010409@canonical.com> <4D06AB66.8090909@euromail.se> <20101214043635.GB12059@salty.local>
In-Reply-To: <20101214043635.GB12059@salty.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSQtu-0008Ga-AW.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PSQtu-0008Ga-AW f5f0c6d6104d214c728324eff9a14889
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 05:36 AM, Peter Hutterer wrote:

> On Tue, Dec 14, 2010 at 12:25:26AM +0100, Henrik Rydberg wrote:
>>>> The envelope contacts serve as a way to detect a small area of fingers or a
>>
>>>> large area of fingers. There is nothing inherently problematic with having one
>>>> or three or more such contacts.
>>>
>>> Then I'm more confused :).
>>>
>>> I see one problem: devices that report two touch points, (X1, Y1) and
>>> (X2, Y2), but in reality the touches could be at (X1, Y2) and (X2, Y1)
>>> instead. Using a rectangle helps resolve this issue for panning and
>>> pinching, though not for rotation.
>>
>>
>> If panning and pinching and rotation could all be recovered properly, then the
>> individual contacts could actually have been reconstructed properly in the first
>> place. This is the whole point - there is not enough information available for
>> rotation to be recovered properly.
> 
> can you post an example event stream of the MT_ENVELOPE tool? I'm having
> trouble wrapping my head around it.


Here is an example for you: You sit in a car. You turn your steering wheel left
or right to follow the road. Now, imagine that 40% of the time, when you turn
left, the car actually turns right. This is the behavior you get from the raw
data. Now, instead soak your gloves in soap. At least now you know that your car
will go straight 100% of the time. The MT_ENVELOPE tool is the soapy glove.
That's all there is to it.

The synaptics driver patch sent recently contains an example event stream
generator, in case you want to dwell on more details.

Personally, I am done bending myself backwards to support "old" or "semi-mt"
hardware I never use myself. If somebody cares deeply enough, send a patch. Or
forever hold your peace.

Thanks.
Henrik
