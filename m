Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1LPKD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:03:59 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4523 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1LPKDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:03:50 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4EEB177A.603@broadcom.com>
Date: Fri, 16 Dec 2011 11:03:38 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Daniel Baluta" <daniel.baluta@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unexpected taint message
References: <4EEB0EFC.5000302@broadcom.com>
 <CAEnQRZA+Om=1VKpRQiSxvRzvkbicmsR=wsyskFu-WQ8HrbuM4Q@mail.gmail.com>
In-Reply-To: <CAEnQRZA+Om=1VKpRQiSxvRzvkbicmsR=wsyskFu-WQ8HrbuM4Q@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62F5C6B55045175317-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 10:29 AM, Daniel Baluta wrote:
> Hello,
> 
> On Fri, Dec 16, 2011 at 11:27 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> To whoever may know,
>>
>> Upon loading our driver module I get the following message:
>>
>> kernel: [  344.805106] Disabling lock debugging due to kernel taint
>>
>> What exactly are the criteria for tainting? Our driver locking strategy
>> is something we want to refactor and having lock debugging during that
>> transition may be a life safer.
> 
> Is your driver GPL licensed?
> 
> thanks,
> Daniel.
> 

Not entirely:

MODULE_LICENSE("Dual BSD/GPL");

Gr. AvS

