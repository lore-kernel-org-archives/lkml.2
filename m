Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1FTQmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:42:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42282 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1FTQmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X2N5JJwv2FM0k+soa1KrRbdD71Vi18bC3fS+69vCnqBSUm3yQMFXBv/mE4V6VMuYY/
         L3AHjIShUWLFzdm+fSmWDe2itHbRWhRqC/ZT4roYy9wzESwLcxvZLiaSHDgEADBvh20Z
         NCQ3rduptXcnf9k1YUAvUW+NMZHMkOVqWRU9U=
MIME-Version: 1.0
In-Reply-To: <20110620160650.GA26623@legolas.emea.dhcp.ti.com>
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
	<Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
	<20110620151522.GN14262@legolas.emea.dhcp.ti.com>
	<BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
	<20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
	<BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
	<BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
	<20110620160650.GA26623@legolas.emea.dhcp.ti.com>
Date: Mon, 20 Jun 2011 18:41:59 +0200
Message-ID: <BANLkTi=nEma5muF9R3_QUzZWWJ64DW9Skw@mail.gmail.com>
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
From: Skacore Systems <skacore.systems@gmail.com>
To: balbi@ti.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Viliam Mateicka <viliam.mateicka@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah I think that one line break and tabs are sabotaging your work.
So stop being an 8====O - hole. No wonder if you are paid by TI that
one line patch into the upstream takes you so long to comprehend.

Vilo

On Mon, Jun 20, 2011 at 6:06 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jun 20, 2011 at 05:57:31PM +0200, Skacore Systems wrote:
>> Oh and I've finally cloned the mainline git. So here it's the last
>> try. I hope the TI people will not sabotage the Samsung's drivers any
>> way longer !!!
>
> Now you're just making an ass of yourself.
>
> what do you think you will get making such kind of statements ? I just
> happen to be hired by TI, there's no such thing as TI trying to sabotage
> Samsung's drivers.
>
> I'll fix this one out myself just to make you stop bothering me, but
> don't expect me to put your patches in my priority list. If you really
> think TI is sabotaging samsung's drivers, look at the big re-factor we
> are doing on the entire Gadget framework, involving not only Samsung's
> drivers but all the others.
>
> Even though you cloned the tree you still make a mistake which will
> prevent me from applying the patch without manually editting it.
>
> On top of that, you decided not to follow our netiquette or our patch
> formatting rules just because you think it's "nonsense". If you really
> think that, why do you even bother sending the patch to this mailing
> list ?
>
>> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
>> index 100f263..b6e1ca5 100644
>> --- a/drivers/usb/gadget/s3c2410_udc.c
>> +++ b/drivers/usb/gadget/s3c2410_udc.c
>> @@ -1567,7 +1567,7 @@ static void s3c2410_udc_command(enum
>> s3c2410_udc_cmd_e cmd)
>
> there shouldn't be this line break here.
>
>>                 return;
>>
>>         if (udc_info->udc_command) {
>> -               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
>> +               udc_info->udc_command(cmd);
>>         } else if (gpio_is_valid(udc_info->pullup_pin)) {
>>                 int value;
>
> tabs where converted into spaces too.
>
> Next time, instead of been such an ass, spend some time learning the
> process we use to do development. You'll see things will go smoother.
>
> --
> balbi
>
