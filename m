Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1C2NFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:05:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46262 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1C2NFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Kg7gqY/3C2j5+XibAplWjpRzLKHzUm5308pVKHnjnH+2NFC0SM9B29F3REKiZo22C/
         Zgdh/zlpNXD7AkjrmzPgupC+pIx2hfwwzF4WyQF6ydhcj/s60WJ1uMyThEMQg/oJ3ZXc
         Xbl0dXBeKtofUVQm2V8q74RRDc/v5cM+anuR4=
MIME-Version: 1.0
In-Reply-To: <1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk>
References: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk>
Date: Tue, 29 Mar 2011 16:05:35 +0300
X-Google-Sender-Auth: fRlEtZQcrEsswrChVB6U41YeYhI
Message-ID: <AANLkTin0bicOYyY2WCaBxN276t5RV-Q9UZVr=WQ6NmQe@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Move the irq wait queue initialisation into the
 ring init
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 3:23 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> Required so that we don't obliterate the queue if initialising the
> rings after the global IRQ handler is installed.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

I applied both of the patches on top of yesterdays git HEAD and I just
get a blank screen after GRUB. No serial or net console here. Do you
want me to try just one of the patches or turn on some debugging
options?

                        Pekka
