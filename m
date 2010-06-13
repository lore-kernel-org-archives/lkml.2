Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0FMKtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 06:49:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:38107 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0FMKtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 06:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZWm8MCZnIJ8w00LzCkMaqVT4wvlAMZwYkBYK+9SbI6SDWcGLRNsWvHxX+pdcSm3XP7
         7SGdv4smYNBQnipFlkVav1AveEcrMiBthiDbU98YVq1Ene4QVYA/KmKYzruYtuz8EWXg
         xg+9snEoryrvfHzn+ZM51IWvG0/eMrBgWgRn4=
MIME-Version: 1.0
In-Reply-To: <80366F5EAAE27640A7221E6EF6AB54E5E8907D@CNSHGSMBS04.ad4.ad.alcatel.com>
References: <80366F5EAAE27640A7221E6EF6AB54E5E8907D@CNSHGSMBS04.ad4.ad.alcatel.com>
Date: Sun, 13 Jun 2010 18:49:10 +0800
Message-ID: <AANLkTinyrZe0Mb7DpoLlYZaXIp6Oxe6ueAbb0YvG7ApB@mail.gmail.com>
Subject: Re: mq_receive failed with errno=512 (ERESTARTSYS)
From: Jerry Wang <jjerrywang@gmail.com>
To: WANG Jerry J <Jerry.j.Wang@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any update?

2010/6/13 WANG Jerry J <Jerry.j.Wang@alcatel-lucent.com>:
>
> In the user space, Can we see ERESTARTSYS? I assume we should see EINTR.
> Am I right?
> How to reproduce this case?
>
> Thanks,
> Jerry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
