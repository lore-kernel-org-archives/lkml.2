Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1DILzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 07:55:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35935 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1DILzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 07:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FApw7vsPQq0+EEIHgnhAkoVsqpGhTGosDa3nQtsMI3XCStVjuffnIveCNTFB4umkos
         gdDgAVWYQ6PCtRQ/gpwAM8BdgLdw+mKqGcIlV8c+dU2BBBXn9k0XqSvvMKXGVY1cSIDp
         eE+0azo3t7nLpnIq/HissHc1fP99TwkqoA98I=
MIME-Version: 1.0
In-Reply-To: <BANLkTikZVDejarZ4O5KgNS7S4fxBLSmANA@mail.gmail.com>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
	<BANLkTikZVDejarZ4O5KgNS7S4fxBLSmANA@mail.gmail.com>
Date: Sat, 9 Apr 2011 20:55:16 +0900
Message-ID: <BANLkTikVeXvfSBS-xLDXVdesKJpKdtUVqg@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mmc: use nonblock mmc requests to minimize latency
From: Jae hoon Chung <jh80.chung@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Per Forlin <per.forlin@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per..

I'm applied your patch..and sent the patch about dw_mmc.c.
I think good this approach..

Tested-by: Jaehoon Chung <jh80.chung@samsung.com>

Regards,
Jaehoon Chung

2011/4/9 Linus Walleij <linus.walleij@linaro.org>:
> On Wed, Apr 6, 2011 at 9:07 PM, Per Forlin <per.forlin@linaro.org> wrote:
>
>> The intention for introducing none blocking mmc requests is to minimize the
>> time between a mmc request ends and another mmc request starts.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org> FWIW, I've looked at the
> patches so many times I'm already blind for any remaining bugs...
>
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
