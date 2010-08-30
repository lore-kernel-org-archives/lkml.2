Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0H3RO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:14:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48004 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0H3ROz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U8TYkYrre5y9wEjkb4wEskYjzm6CwCFEtXPzHE+P/3GZfkTPvXDSH9oOK73TBDTFXU
         vqybSCFQJOlsjxDO27fFHNhsHhhoNx/paUirOG0ejSjRqbaZv7lVYqc24yl3zREapuf2
         /j91bll7vjwZAJLGE8x8TJW6HuZePDMWm4Hno=
MIME-Version: 1.0
In-Reply-To: <4C7BE3AE.8020204@suse.de>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	<i5fr6h$ih6$1@dough.gmane.org>
	<4C7BE3AE.8020204@suse.de>
Date: Mon, 30 Aug 2010 12:14:53 -0500
Message-ID: <AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
Subject: Re: Linux 2.6.36-rc3
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Miguel Calleja <mcalleja1@telecable.es>,
        LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Shirish S Pargaonkar <shirishp@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:00 PM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> (Cc linux-cifs@vger.kernel.org)
>
> Couldn't get a chance to check this, but I guess this is perhaps due to
> the recent crypto patches..

Suresh, yes, cifs auth and signing code using kernel crypto (shash) apis.

fs/cifs/Kconfig

        select CRYPTO_MD5
        select CRYPTO_ARC4


>
> On 08/30/2010 02:17 PM, Miguel Calleja wrote:
>> CIFS does not build without CRYPTO selected.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> --
> Suresh Jayaraman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
