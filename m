Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1CGNyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 08:54:43 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3741 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab1CGNyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 08:54:40 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
cc: "Brett Rudley" <brudley@broadcom.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
 <op.vryqz6qt3ri7v4@arend-laptop>
 <AANLkTinbrbkUO-ycAsX4cLEoM6avPeiYEZZ-zKtavfqq@mail.gmail.com>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi
 switch to OFF
To: "Francis Moreau" <francis.moro@gmail.com>
Date: Mon, 7 Mar 2011 14:54:22 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vry7kwq83ri7v4@arend-laptop>
In-Reply-To: <AANLkTinbrbkUO-ycAsX4cLEoM6avPeiYEZZ-zKtavfqq@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 616A3BAD3T83112815-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 12:33:07 +0100, Francis Moreau
<francis.moro@gmail.com> wrote:

>
> Would it be possible to submit it one more time ?
>

I don't know what the origin is of your kernel so please provide some  
details on that. The patch itself can be found in the linuxdriver email  
archive:

http://driverdev.linuxdriverproject.org/pipermail/devel/2011-January/011381.html

Not sure whether it applies to whatever you have. I just tried your  
scenario with my driver and hardware and no freezes during boot.

>
> Thanks

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the
human
mind to correlate all its contents." - "The Call of Cthulhu"

