Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0HZHnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:43:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47873 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0HZHnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=galVEubX118tGwz3r1EKnZGtgRN2kAKG79i2pUaDJb1JN7Rhc4CiK232BRsEXobrC6
         TFQmI0+cG0oxP8MKmAE73EoRAOrxiAKDAdTH+uMhVOaL2cmA/O0GHXYPBCeg3t2oeKh7
         aTsQxGNdxJa7KEXf8z6ufC3ogWQflkHDe2HpM=
MIME-Version: 1.0
In-Reply-To: <4C7606A9.40103@canonical.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
	<1282120734-11635-1-git-send-email-ike.pan@canonical.com>
	<alpine.LFD.2.00.1008251656090.3037@localhost.localdomain>
	<AANLkTi=STq=_K2NPnK4GM+XwruaR09m6QJ7nkuCJVQvB@mail.gmail.com>
	<4C7606A9.40103@canonical.com>
Date: Thu, 26 Aug 2010 09:43:19 +0200
Message-ID: <AANLkTik5jZ69_=yzQaheUrxPvnnFFdyysjxndVKfdh1d@mail.gmail.com>
Subject: Re: [PATCH 8/8] ideapad: Change the driver name to ideapad_laptop
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: Len Brown <lenb@kernel.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 8:16 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> On 08/26/2010 01:43 PM, Corentin Chary wrote:
>> On Wed, Aug 25, 2010 at 10:56 PM, Len Brown <lenb@kernel.org> wrote:
>>>>  drivers/platform/x86/ideapad_acpi.c   |  381 ---------------------------------
>>>>  drivers/platform/x86/ideapad_laptop.c |  381 +++++++++++++++++++++++++++++++++
>>>
>>> Acked-by: Len Brown <len.brown@intel.com>
>>>
>>> thanks,
>>> Len Brown, Intel Open Source Technology Center
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Probably not very important .. but .. other drivers are called *-laptop.c, not
>> *_laptop.c ..
>>
>> asus-laptop.c classmate-laptop.c compal-laptop.c dell-laptop.c eeepc-laptop.c
>> fujitsu-laptop.c msi-laptop.c panasonic-laptop.c sony-laptop.c topstar-laptop.c
>>
> I choose _laptop.c not -laptop.c because when modprobe. We are using
> "modprobe asus-laptop", but when removing, using "modprobe asus_laptop".
>

Hum, that's a "bug" in asus-laptop, because I used KBUILD_MODNAME
(asus_laptop) instead
of "asus-laptop" as the driver name. And I don't know if I can change
that now without breaking
backward compatibility.

But other drivers should work (I tested sony-laptop).

-- 
Corentin Chary
http://xf.iksaif.net
