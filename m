Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1FOKMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:12:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40258 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab1FOKMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YUOvurSaJ6BZ6vj9FENW/YbC3vTcQ3avxT89dYK7h5W3zcupzidtwjHYPb0j6VSgZZ
         On7lxhJQLv0FDELOLuWUtKxpmG/lGoAoMYeCxSm46rwNFJYtTWfFdRIT/jRe9Yf4eXpx
         g9SFgs++P0H6U2h7MHbIl/a8whjKJyZLQxwjM=
MIME-Version: 1.0
In-Reply-To: <25c1ce98c838621aeb514e6e0e843949.squirrel@webmail.sf-mail.de>
References: <20110614070732.GA3355@maxin>
	<20110614071540.GE8141@htj.dyndns.org>
	<BANLkTimHjVX6ymALT-ZBeSs1S+PRDRwQaQ@mail.gmail.com>
	<20110615081317.GL8141@htj.dyndns.org>
	<25c1ce98c838621aeb514e6e0e843949.squirrel@webmail.sf-mail.de>
Date: Wed, 15 Jun 2011 11:12:44 +0100
Message-ID: <BANLkTimaBC0uGfcoX9mBLLdGOo7Mj5CJwg@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] devres: Fix possible use after free
From: Maxin B John <maxin.john@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, segooon@gmail.com,
        jkosina@suse.cz, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eike,

On Wed, Jun 15, 2011 at 11:00 AM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
>
> Sounds good. And please merge both patches together.
>
I'll merge both patches into a single patch and repost it today itself.

Warm Regards,
Maxin
