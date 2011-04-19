Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1DSJcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:32:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:33345 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1DSJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:32:48 -0400
Message-ID: <4DAD56B9.8020909@ahsoftware.de>
Date: Tue, 19 Apr 2011 11:32:41 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Implement /dev/byte (a generic byte source similiar
 to /dev/zero)
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>	<BANLkTi=yaXOWnUi2s1A-BtoAFgjExX8q4w@mail.gmail.com>	<4DAD48FC.5040003@ahsoftware.de> <20110419094436.0b667410@lxorguk.ukuu.org.uk> <4DAD5046.3030008@ahsoftware.de>
In-Reply-To: <4DAD5046.3030008@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 19.04.2011 11:05, schrieb Alexander Holler:

>> Implementationwise I think I would have gone for allocating a new device
>> and range of 256 minors - that would avoid the funky stuff setting what
>> it fills with as you'd just fill with the minor number.
>
> I thought about that too, but that would have been to easy (and static). ;)
>
> And the usage of file descriptors was the only idea I've come up with,
> which is multitasking and multiuser aware.

If I add the possibility to use minors to set the default value (but 
still leave the possibility to change the default dynamically), would 
that raise the chance to become included? ;)

Regards,

Alexander
