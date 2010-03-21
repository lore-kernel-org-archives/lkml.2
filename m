Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0CUUXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:23:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:12059 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0CUUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=f6ut4ToWsiWcQTRkidyETBo+XzBbVsTP/Ca1mKujUj2NR0KxCSlxbkw8vq2djrvk4r
         /u36bVCziI8F5Yags+go6/WBKFu8UdpOZn4PhuhovXSpBhiNKcigt6A0R5t3LOVh3B7/
         B2gf4Am6vOoaEguKpIKS8fAJBpSxpEA+Qf4e0=
MIME-Version: 1.0
In-Reply-To: <20100321200544.GE1933@elf.ucw.cz>
References: <1269114239-4007-1-git-send-email-lindley@coyote.org>
	 <20100321200544.GE1933@elf.ucw.cz>
Date: Sun, 21 Mar 2010 22:23:27 +0200
X-Google-Sender-Auth: 8f2f55e24e5b3df8
Message-ID: <84144f021003211323i341b93edie6e778fb236c8cbe@mail.gmail.com>
Subject: Re: [PATCH] staging: winbond: scan_s.h Coding style fixes.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 10:05 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sat 2010-03-20 20:43:59, Lars Lindley wrote:
>> I fixed all things reported by checkpatch.pl except a couple
>> of long lines and typedefs.
>> I also removed "commented away" code and a history comment.
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>
> ACK.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
