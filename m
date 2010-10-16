Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0JPVMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 17:12:17 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34695 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0JPVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 17:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Rra2irbrkC/A9NYc7JFw99+rTAXlHJf1n9Wp/8GKjPpIe//J70FrRl+YbxTnqMLFSa
         L4UqKXVGkSc0aua4FEZy+rXWjonhDxpG0GjEVmOP7wi4dfdqLzJ/qc05agU5HOEUGMBA
         ewLYEMCyJhKgy6aH1bOIFT+w+5B6LQmctdhlI=
MIME-Version: 1.0
In-Reply-To: <4CB9DA37.6080504@gmail.com>
References: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
	<1287235613-1545-2-git-send-email-tdent48227@gmail.com>
	<4CB9D854.7050806@gmail.com>
	<4CB9DA37.6080504@gmail.com>
Date: Sat, 16 Oct 2010 17:12:15 -0400
Message-ID: <AANLkTimgXSNPrQwnDoPhERmc+JsK50x0uEmrD5kq+wux@mail.gmail.com>
Subject: Re: [PATCH 02/05] Drivers: char: impi: Makefile: replace the use of
 <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
        mhw@wittsend.com, minyard@acm.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/10, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/16/2010 06:52 PM, Jiri Slaby wrote:
>> On 10/16/2010 03:26 PM, Tracey Dent wrote:
>>> Changed <module>-objs to <module>-y in Makefile.
>>>
>>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>>> ---
>>>  drivers/char/ipmi/Makefile |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/char/ipmi/Makefile b/drivers/char/ipmi/Makefile
>>> index eb8a1a8..16a9364 100644
>>> --- a/drivers/char/ipmi/Makefile
>>> +++ b/drivers/char/ipmi/Makefile
>>> @@ -2,7 +2,7 @@
>>>  # Makefile for the ipmi drivers.
>>>  #
>>>
>>> -ipmi_si-objs := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
>>> +ipmi_si-y := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
>>
>> NACK (and all of these). This will try to build 4 modules instead of
>> one. Read Documentation/kbuild/makefiles.txt
>
> Please disregard my NACK, I misread the patch.
>

Okay, no problem. So instead of getting your NACK does it get a ACK by you?

> regards,
> --
> js
>

Thanks,

Tracey D
