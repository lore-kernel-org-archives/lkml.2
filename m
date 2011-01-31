Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1AaVbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:31:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57443 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1AaVbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S305DOU7UBJYe9c1bv/aMgL4HGobGPBiT0ZbfACqsHnkvDv70tPkljW+riWqXpPOrj
         LjSZqzLvq/FFLpfLbEfN0vACymApqXk6FzhMCq+ZckZotY6xO5MXdxjZOnVWbHg3LG56
         0/zmLuYpr822nyhpxrGGLm/AJbv8ipNtvtEdA=
MIME-Version: 1.0
In-Reply-To: <8739oi7z4m.fsf@ti.com>
References: <1295604084-27761-1-git-send-email-weber@corscience.de>
	<AANLkTikSznkcNwkVaPswx=zr8FFGQPVMw_AebF9ymZLE@mail.gmail.com>
	<8739oi7z4m.fsf@ti.com>
Date: Mon, 31 Jan 2011 22:31:09 +0100
Message-ID: <AANLkTi=HxnPVu83CpodFA4rLipcz1Oie2co49S1=+1M6@mail.gmail.com>
Subject: Re: [PATCHv3] OMAP: Enable Magic SysRq on serial console ttyOx
From: Thomas Weber <thomas.weber.linux@googlemail.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Govindraj <govindraj.ti@gmail.com>, Thomas Weber <weber@corscience.de>,
        linux-omap@vger.kernel.org, manjugk@ti.com, gadiyar@ti.com,
        tony@atomide.com, govindraj@ti.com, gregkh@suse.de,
        andrei.emeltchenko@nokia.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:47 PM, Kevin Hilman <khilman@ti.com> wrote:
> Govindraj <govindraj.ti@gmail.com> writes:
>
>> On Fri, Jan 21, 2011 at 3:31 PM, Thomas Weber <weber@corscience.de> wrote:
>>> Magic SysRq key is not working for OMAP on new serial
>>> console ttyOx because SUPPORT_SYSRQ is not defined
>>> for omap-serial.
>>>
>>> This patch defines SUPPORT_SYSRQ in omap-serial and
>>> enables handling of Magic SysRq character.
>>>
>>> Further there is an issue of losing first break character.
>>> Removing the reset of the lsr_break_flag fixes this issue.
>>>
>>> Signed-off-by: Thomas Weber <weber@corscience.de>
>>
>>
>> Acked-by: Govindraj.R <govindraj.raja@ti.com>
>> Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
>>
>
> Acked-by: Kevin Hilman <khilman@ti.com>
>
> Greg, this one should go for .38-rc.   Feel free to merge, or we can
> take it through the OMAP tree with your ack.
>
> Thanks,
>
> Kevin
>
> --

Hello,
should I rebase this patch, because it does not apply after movement
of driver/serial to driver/tty/serial?

Thomas
