Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1KRUJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:09:18 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2610 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab1KRUJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:09:16 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4EC6BB5E.4010101@broadcom.com>
Date: Fri, 18 Nov 2011 21:09:02 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929
 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Nico Schottelius" <nico-nospam@schottelius.org>,
        "Nico -telmich- Schottelius" <nico-linux-20111118@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: b43: BCM 4331: MacBook 8,1: No connection after suspend
References: <20111118173242.GA2101@schottelius.org>
 <20111118173921.GB2101@schottelius.org> <4EC6B9E9.50204@broadcom.com>
In-Reply-To: <4EC6B9E9.50204@broadcom.com>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62D8628E3IW5973949-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 09:02 PM, Arend van Spriel wrote:
> On 11/18/2011 06:39 PM, Nico Schottelius wrote:
>> Nico -telmich- Schottelius [Fri, Nov 18, 2011 at 06:32:42PM +0100]:
>>> Hello,
>>>
>>> new notebook, new problems (*):
>>
>> + full dmesg attached.
>>
> 
> It seems you are running b43 + bcma. Adding Rafał and friends.
> 
> Gr. AvS

Hi Rafał,

In brcmsmac we reprogram the PCI BAR windows upon resume. Not sure if
that is done or needed in bcma, but may be worth checking.

Gr. AvS

