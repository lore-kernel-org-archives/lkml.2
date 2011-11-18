Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab1KRXIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:08:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50898 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab1KRXIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <4EC6BB5E.4010101@broadcom.com>
References: <20111118173242.GA2101@schottelius.org>
	<20111118173921.GB2101@schottelius.org>
	<4EC6B9E9.50204@broadcom.com>
	<4EC6BB5E.4010101@broadcom.com>
Date: Sat, 19 Nov 2011 00:08:51 +0100
Message-ID: <CACna6ryw9gC5CnY-ex45JFmQtXRxs8NX9ADkqVZrOj5CCtjiVw@mail.gmail.com>
Subject: Re: b43: BCM 4331: MacBook 8,1: No connection after suspend
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-nospam@schottelius.org>,
        Nico -telmich- Schottelius 
	<nico-linux-20111118@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/18 Arend van Spriel <arend@broadcom.com>:
> On 11/18/2011 09:02 PM, Arend van Spriel wrote:
>> On 11/18/2011 06:39 PM, Nico Schottelius wrote:
>>> Nico -telmich- Schottelius [Fri, Nov 18, 2011 at 06:32:42PM +0100]:
>>>> Hello,
>>>>
>>>> new notebook, new problems (*):
>>>
>>> + full dmesg attached.
>>>
>>
>> It seems you are running b43 + bcma. Adding Rafał and friends.
>>
>> Gr. AvS
>
> Hi Rafał,
>
> In brcmsmac we reprogram the PCI BAR windows upon resume. Not sure if
> that is done or needed in bcma, but may be worth checking.

Good point.

Please reload b43 *and bcma*. Both drivers. Share your results.

-- 
Rafał
