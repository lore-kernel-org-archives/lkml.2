Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0C0RqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 13:46:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35639 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab0C0RqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 13:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fqNzs8y2CP9L3+aLzLAAMMUaM83CBG6UjgqMGOY4d9v/oXwFPnFCSTIjnfuGdv/C3X
         3gvEWy76Bn85yO5mI+luBG+HXMrUswf9+FkpJNkoSu9ZD3JkNofHMYv1eFzUKObzmzm6
         Wh8iltWoO4Fqs1JJsZvMs+z0WDYXkUsuSOoT8=
Message-ID: <4BAE4464.9060909@gmail.com>
Date: Sat, 27 Mar 2010 11:46:12 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?UTF-8?B?77+9IEVuZ2Vs?= <joern@dublin.logfs.org>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       romieu@fr.zoreil.com
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI Express
 devices (v2)
References: <20100315150806.GA15354@Dublin.logfs.org> <20100315151041.GA15667@Dublin.logfs.org> <20100315.115748.13754030.davem@davemloft.net> <51f3faa71003151628g5edc4d7av8916ac76cb337bfe@mail.gmail.com> <20100316083501.GA3489@Dublin.logfs.org> <51f3faa71003161630g69160ea9tc1a2d448682632e5@mail.gmail.com> <51f3faa71003251756h17374375yd3a5d2acee2ffab9@mail.gmail.com> <20100326091234.GA11959@Dublin.logfs.org> <4BAD65A0.7090309@gmail.com> <20100327063838.GB11959@Dublin.logfs.org>
In-Reply-To: <20100327063838.GB11959@Dublin.logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2010 12:38 AM, � Engel wrote:
> On Fri, 26 March 2010 19:55:44 -0600, Robert Hancock wrote:
>>
>> Well, that one's 36 bits, but it's unclear whether that driver would
>> actually be likely to access anything over 4GB. It's possible that
>> there's just some general problem with 64-bit DMA on that machine.
>
> That may very well be.  I've had trouble using a PCIe card in that
> machine as well.  "Solution" was to buy a different computer.  Sad, I
> know, but not my money.

Hm, do you recall/have the details of what happened with the other card?

It's possible this is some general problem with that machine/motherboard 
and not actually an issue with what the driver is doing. What kind of 
board is that?

>
>> The fact that even stuff like lspci and MII is breaking seems odd,
>> though. It could be that model of card doesn't like the PCIDAC register
>> bit being set (maybe it means something different on that model, or
>> something).
>>
>> I suppose a publicly accessible datasheet for these chips is too much to
>> hope for?
>
> Which chips?
>
> J�rn
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

