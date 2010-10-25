Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0JYSmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:42:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57341 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0JYSmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g7ecnT+crS6S35Bh954qNvIq2/9/UPGtBQ0WettRAMxnnWx6IXAmoq3q5NM1wmXICE
         xUYm68DX0UQ9t2qaQvXwKsXlTDk3f8bMV9HDIG0y69pfz+lQpFCfvgfVLzY+fasnZCyf
         vRaa3ys44WUwOROeqOtovNLrArihDE0HJ3boo=
MIME-Version: 1.0
In-Reply-To: <201010251127.37374.dmitry.torokhov@gmail.com>
References: <20101023221253.GA4829@hathor>
	<201010251127.37374.dmitry.torokhov@gmail.com>
Date: Mon, 25 Oct 2010 12:42:41 -0600
Message-ID: <AANLkTikcnJQnWYP+BTpUAvizU1iwwUo4=Nabe0L6xMXa@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi.c: Add key_entry for a lone FN keypress
From: Azael Avalos <coproscefalo@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jon Dowland <jmtd@debian.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It actually generates on key press/release with different key codes,
0x17f and 0x100 respectively. So I think that both should be added.

On Mon, Oct 25, 2010 at 12:27 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Saturday, October 23, 2010 03:12:53 pm Jon Dowland wrote:
>> A lone FN key press on a Toshiba Portégé R700 without another key in
>> conjunction results in an ACPI event and a spurious error message on
>> the console.
>>
>> Add a key entry to map this event to a KEY_UNKNOWN keypress silences
>> this message.
>>
>
> Well, if FN key can generate separate events then we should report
> KEY_FN, not KEY_UNKNOWN.
>
> Thanks.
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
-- El mundo apesta y vosotros apestais tambien --
