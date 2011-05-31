Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab1EaTe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:34:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1EaTe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i864t5iSuiyNeUfhkp/lNlsXQETMrbUPhzzKCGTjaIhxKCTAnTJOFkk050oXzz5WG5
         hxH4r5Kymzsa+wRzRg5evlQDYl2uPcLjxqjrpR/LJ8zICbdvHcaD4TrjrgGB1iy7+31y
         5snF0K1q0WUoVJlHMXjs18AQUhd4wVGr1SZ0M=
MIME-Version: 1.0
In-Reply-To: <8eace637-27d2-41c5-bcbd-0087d6c75a75@email.android.com>
References: <1306834660-15374-1-git-send-email-geert@linux-m68k.org>
	<8eace637-27d2-41c5-bcbd-0087d6c75a75@email.android.com>
Date: Tue, 31 May 2011 21:34:27 +0200
X-Google-Sender-Auth: CYZoOp8Q3HJkbCHRtLxZxTgdZpY
Message-ID: <BANLkTi=bKG4b6ziSkCqEfgqJ3VmktwVc7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging/iio: Make IIO depend on GENERIC_HARDIRQS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "jonathan.cameron@gmail.com" <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jeff Mahoney <jeffm@suse.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 13:01, jonathan.cameron@gmail.com
<jic23@cam.ac.uk> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>On m68k (which doesn't support generic hardirqs yet):

[...]

>>Hence IIO_TRIGGER should depend on GENERIC_HARDIRQS.
>>But as IIO_TRIGGER and IIO_RING_BUFFER form a maze of dependencies and
>>selects,
>>just make the whole IIO subsystem depend on GENERIC_HARDIRQS.
>>
>>This dependency also covers !S390, so that one can be removed again.
> Dratt  We talked about this and thought S390 was the only non generic hard irq left.  Should have played safe sorry!

I hope s390 will be the only one soon ;-)

>>Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
