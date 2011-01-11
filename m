Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1AKRdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:33:17 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61073 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1AKRdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VstY6kMApsv7w3+rWglnakjk1jYL2id9kUOscMt++9tGDSSx0LDJwyCtNlLu+UxvRP
         BWc/byPr09uZlp6fCnKChu7iv3aojSSzMJ0TD33taw3kUpKVtm8YYCWezQC273ZBadjK
         8Hk0F3Y6v/+/ezvZDWzrVfFm6Aui0i9Rkbq0w=
MIME-Version: 1.0
In-Reply-To: <AANLkTimDHO=oiR3ncX4BLmMJaoUAmaQL6r=bZcWV4-Gg@mail.gmail.com>
References: <alpine.LNX.2.00.1101110044580.32164@swampdragon.chaosbits.net>
	<AANLkTimDHO=oiR3ncX4BLmMJaoUAmaQL6r=bZcWV4-Gg@mail.gmail.com>
Date: Tue, 11 Jan 2011 19:33:13 +0200
X-Google-Sender-Auth: T2uzz5VRddEpFA8X0r2kmUbgQRU
Message-ID: <AANLkTinEbfAsMiFaoC_XBTDOD7pOoUeTBXjXfiiOKof7@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Don't leak mem in error path of rt2x00lib_request_firmware()
From: Pekka Enberg <penberg@kernel.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 7:30 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>> We need to release_firmware() in order not to leak memory.
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>
> I can assume that release_firmware() checks if 'fw' is null?

Yes, it does.

> If so:
>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
