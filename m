Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0CVK4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:56:21 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:48245 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0CVK4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rAZLZdKiq6KqdV3GNnYoD862mH79chJqSi+IYJaXMuR+1LI+0pQCvgwEeZqLeMEHnv
         416nwjXvnb7tl15RZ6w2IZNF9O8eztB8H/aB+2xTu/+HLuSvqbWdrTxO7aGV+Tj39cuW
         Vkt6x8L1viCRipBJWKsyw3RQhkl6xmisNuhGk=
MIME-Version: 1.0
In-Reply-To: <4BA74CA2.7070305@coyote.org>
References: <1269210658-9518-1-git-send-email-lindley@coyote.org>
	 <4BA71949.9040809@cs.helsinki.fi> <4BA73C4C.4020708@coyote.org>
	 <84144f021003220257k1bd88315x3eb21057b4696a8f@mail.gmail.com>
	 <4BA74CA2.7070305@coyote.org>
Date: Mon, 22 Mar 2010 12:56:18 +0200
X-Google-Sender-Auth: cdf9de3341e798d2
Message-ID: <84144f021003220356m134c864dwdc75de6f5003f56b@mail.gmail.com>
Subject: Re: [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 12:55 PM, Lars Lindley <lindley@coyote.org> wrote:
> Here's a new patch against master that fixes CamelCase too.
>
> [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
>
> I fixed the checkpatch things except a couple of long lines.
> I also removed hungarian notation and CamelCase from the argument names
> and some "commented away" code.
>
> Signed-off-by: Lars Lindley <lindley@coyote.org>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
