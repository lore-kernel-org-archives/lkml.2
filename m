Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0CUUdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:33:23 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:40923 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab0CUUdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YNUKGW9ukaIV45EzZIyX5eE3i3yrq98tA7cOEqRVE/jA7M3nxHKrYpHgdcVEC//0q8
         MjJ5QSqT6mOZyajBjQjA5Hki816KIxNFE6BGTjfxRi1NOCc9/Opa4HMHowuAGFCWV66j
         dH8laNnT6daa1LyilnA2TFCQT7bWoIxeObNh0=
MIME-Version: 1.0
In-Reply-To: <20100321201221.GI1933@elf.ucw.cz>
References: <1269190503-12050-1-git-send-email-lindley@coyote.org>
	 <20100321201221.GI1933@elf.ucw.cz>
Date: Sun, 21 Mar 2010 22:25:16 +0200
X-Google-Sender-Auth: 592f81a422b8c674
Message-ID: <84144f021003211325m7ab3f65ej901c6ad93cab8c69@mail.gmail.com>
Subject: Re: [PATCH] staging: winbond: sme_api.h Coding style fixes.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 10:12 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sun 2010-03-21 17:55:03, Lars Lindley wrote:
>> I fixed the things reported by checkpatch.pl except
>> one long line and a __inline.
>> I also removed commented away code and versioning comments.
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>
> ACK.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

>> @@ -18,42 +12,42 @@
>>  #include "localpara.h"
>>
>>  /****************** CONSTANT AND MACRO SECTION ******************************/
>> -#define _INLINE      __inline
>> +#define _INLINE                              __inline
>
> doing s/_INLINE/__inline/ on whole sources would be nice....

We probably can just get rid of most of the inlines in the driver code, I think.
