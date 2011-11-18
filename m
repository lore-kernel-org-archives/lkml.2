Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1KRUDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:03:03 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1534 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1KRUDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:03:01 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4EC6B9E9.50204@broadcom.com>
Date: Fri, 18 Nov 2011 21:02:49 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929
 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Nico Schottelius" <nico-nospam@schottelius.org>,
        "Nico -telmich- Schottelius" <nico-linux-20111118@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: b43: BCM 4331: MacBook 8,1: No connection after suspend
References: <20111118173242.GA2101@schottelius.org>
 <20111118173921.GB2101@schottelius.org>
In-Reply-To: <20111118173921.GB2101@schottelius.org>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62D8641A3IW5972936-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 06:39 PM, Nico Schottelius wrote:
> Nico -telmich- Schottelius [Fri, Nov 18, 2011 at 06:32:42PM +0100]:
>> Hello,
>>
>> new notebook, new problems (*):
> 
> + full dmesg attached.
> 

It seems you are running b43 + bcma. Adding Rafał and friends.

Gr. AvS

