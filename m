Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0EVJe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 05:34:27 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:51428 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0EVJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 05:34:25 -0400
Message-ID: <4BF7A4E8.3050806@seas.upenn.edu>
Date: Sat, 22 May 2010 05:33:28 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se> <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com> <4BF6B673.1080507@euromail.se> <20100521165218.GA26439@core.coreip.homeip.net> <4BF6BB43.2020405@euromail.se> <20100521172222.GB26439@core.coreip.homeip.net> <4BF6C303.7030804@euromail.se> <20100521174140.GA23155@core.coreip.homeip.net> <4BF6C7B6.2020008@euromail.se>
In-Reply-To: <4BF6C7B6.2020008@euromail.se>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/10 13:49, Henrik Rydberg wrote:
> Dmitry Torokhov wrote:
>>
>> I guess this is where our disconnect lies as when I am looking at the
>> event names I view all *_MT_* events as related to the multitouch
>> protocol handling.
>>
> 
> Yes. It is true that slot control is MT related, but I am looking at this from
> the perspective of future expansions like KEY_MT,  KEY_REL, and such, finding a
> way to signal to user space which events are handled via slots. If we had
> ABS_MT_SLOT, we would most likely get applications which store ABS_MT_SLOT as an
> attribute of the slot together with ABS_MT_POSITION_X, ABS_MT_TOUCH_MAJOR, etc,
> which is just not right. So the proposal is ABS_SLOT. May we have your verdict,
> please. :-)
> 
> Henrik
> 

How many fingers can type on cap of a key?

(sorry, couldn't resist).


Seems to me like part of the problem here is still the overlap between tracking
id and slot id.

Rafi
