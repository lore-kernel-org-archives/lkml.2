Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0KYOBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:01:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40108 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0KYOB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xz/o9ztGZI6k6MxHu127ud5lw7GSicMa3HMVoJ69BvKTqFdUSKLHo1bx311onPZRjq
         jOpjnRHYQUC8AuW6/H01AUOdLnFP34bPYaeln4Cuj4YyXZTYRtN8xTi7Ub42+MJGpuzP
         T7uGZ+5/31mFk2GMIyYWhVIOK5NsBia0pbRUU=
MIME-Version: 1.0
In-Reply-To: <1290692075.689.20.camel@concordia>
References: <1290607413.12457.44.camel@concordia>
	<1290692075.689.20.camel@concordia>
Date: Thu, 25 Nov 2010 15:01:27 +0100
X-Google-Sender-Auth: Ckong4qhIcssKb7d-UbKPdNxJTs
Message-ID: <AANLkTim9fPPWO-240dmavng+j=70G8Y4P-+j3Y+OZTL0@mail.gmail.com>
Subject: Re: RFC: Mega rename of device tree routines from of_*() to dt_*()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: michael@ellerman.id.au
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 14:34, Michael Ellerman <michael@ellerman.id.au> wrote:
> I've left for_each_child_of_node(), because I read it as "of", but maybe
> it's "OF"?

I always read it as "for each child-OF-node", so I would rename it to
"dt_for_each_child_node".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
