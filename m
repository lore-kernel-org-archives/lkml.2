Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab0LITLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:11:41 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:44973 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756688Ab0LITLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:11:31 -0500
Message-ID: <4D0129D3.9040408@euromail.se>
Date: Thu, 09 Dec 2010 20:11:15 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
References: <4CFF49BC.8030202@euromail.se> <20101209085814.GA8821@core.coreip.homeip.net> <20101209090826.GB8821@core.coreip.homeip.net> <4D011FA5.7000102@euromail.se> <20101209184807.GA23781@core.coreip.homeip.net>
In-Reply-To: <20101209184807.GA23781@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQltc-00060y-3c.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQltc-00060y-3c 7eb71da69fae29e54d0b9fe002b00759
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 07:48 PM, Dmitry Torokhov wrote:

> On Thu, Dec 09, 2010 at 07:27:49PM +0100, Henrik Rydberg wrote:
>>> Input: include MT library as source for kerneldoc
>>
>>>
>>> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>>
>>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>>> ---
>>
>>
>> Looks good. Namewise, it means we stick to the current names for a bit, then?
> 
> I'd prefer moving to input/mt.h before input-mt.h started spreading
> throughout the drivers. I could sit on the doc pluggin patch or you can
> take it through you tree (adjusting as apporpriate).
> 


I'll take it, thanks.

Henrik

