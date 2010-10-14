Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0JNVSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:18:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62155 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0JNVSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N9zC4UFZnXMqogw8SmI8jFiF1QTjl41LVbXDLh6cOiqkYgrl+msJdF8QClJExvimOD
         xIUhk+yu8aL6T2+54YIdwK5BlgSBsEE/LgqYTNs3J9NnFfIiugp1qR7fXgHjYyU53/OV
         OtfD6lpwzeZtb6FmVKCelp+HXHF5BGHQLSZxE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimKtTo=Lh6CzEHhZPLUNgU87uvw+mX+zKmxzJAB@mail.gmail.com>
References: <AANLkTim2_St6Z9dLHaFxfcufM7gf=B_9ouYZWCb5M9KL@mail.gmail.com>
	<AANLkTimKtTo=Lh6CzEHhZPLUNgU87uvw+mX+zKmxzJAB@mail.gmail.com>
Date: Thu, 14 Oct 2010 14:18:08 -0700
Message-ID: <AANLkTimm1R7JP-8QbYr1L+MMLeAWKs01wreWqtPBa_g7@mail.gmail.com>
Subject: Re: commit 0eead9ab breaks ia64 build
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 2:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> IOW, like the attached. Does that work for you?

Yes. That works for me.

Thanks

-Tony
