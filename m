Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0FNLc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:32:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59707 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0FNLc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iDPkJdUCQuzLsVAzGLQZbRvCvwT/1A+XS0zyS3b8b7jr8aU3TVYfPahKuu/117iBP9
         3ApL2Pksw9XRb1VhXVoNm1rXFQ2s9yYMCNIPBk1+tBX0jzKjF+227wVAGB5I6aA2Ewqj
         sCWBjSHMh6L6WuUw+/zHXI4pYPDmp3tsUQh08=
MIME-Version: 1.0
In-Reply-To: <38a51c60af41f83d891a156b3b99fa35a383b470.1276503768.git.m.nazarewicz@samsung.com>
References: <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
	<38a51c60af41f83d891a156b3b99fa35a383b470.1276503768.git.m.nazarewicz@samsung.com>
Date: Mon, 14 Jun 2010 19:32:56 +0800
Message-ID: <AANLkTind4hJcY6vUiAWwZncdB3TuW76951m-3CaLwBzx@mail.gmail.com>
Subject: Re: [PATCHv4.1 07/13] USB: gadget: g_ether: updated INF file
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 4:43 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:
> Updated the INF file for the g_ether gadget.  It should work with most
> recent Windows systems now.  The file has been also renamed to
> linux-rndis.inf rather then linux.inf.
>
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> On Wed, 09 Jun 2010 17:33:51 +0200, Greg KH <greg@kroah.com> wrote:
>> How about putting the following on the file:
>>       ; based on a example .inf file that was:
>>       ;       Copyright (c) Microsoft Corporation
>>       ; and released under the MLPL as found at
>>       ; http://msdn.microsoft.com/en-us/cc300389.aspx#MLPL
>>       ; For use only on Windows operating systems.
>>       ;
>
> As requested only with a little bit different wording.
>
> Still, I am not sure what to do with the serial INF.
> I cannot even find the original file Xiaofan posted
> not mentioning any associated license.  I mean, I would
> leave it as is without changes but dunno...

I think all the INF file templates ultimately comes
from DDK/WDK.

For example, the RNDIS template is from here. And the title
says WDK.
http://msdn.microsoft.com/en-us/library/ff570620%28VS.85%29.aspx

For the CDC-ACM INF, the original template may well be from an ancient
DDK. Anyway, here are some places to infer the CDC-ACM
INF file.
http://support.microsoft.com/kb/837637/en-us (important for Vista/Win7)
http://msdn.microsoft.com/en-us/library/ff542605%28VS.85%29.aspx
(same as above).
http://msdn.microsoft.com/en-us/library/ff543241.aspx (for 2000/XP)
http://msdn.microsoft.com/en-us/library/ff542491%28v=VS.85%29.aspx
http://msdn.microsoft.com/en-us/library/ff542559.aspx

Worse come worse, you might contact Microsoft about the license.
The Microsoft Driver News group has a lot of experts including
Microsoft employees who are very helpful.
microsoft.public.development.device.drivers


-- 
Xiaofan http://mcuee.blogspot.com
