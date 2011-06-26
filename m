Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab1FZILG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 04:11:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49974 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1FZILA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 04:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FEV+ieSCLM2jvPL9X82k8OU6qH5ZBRUEBRABYEN4SimiSgRciaL0t/yIBRovUnlAnA
         JoMQUWcy58xwmoBtAixqIRiRj92BLy8HIYD3NWpqaexA6kcwiYZUTiv2FhYW8VVca9wk
         gW7D4FDORzV6ZzbXscAzKw+7mXNqaNhAWZi7E=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=bKG4b6ziSkCqEfgqJ3VmktwVc7A@mail.gmail.com>
References: <1306834660-15374-1-git-send-email-geert@linux-m68k.org>
	<8eace637-27d2-41c5-bcbd-0087d6c75a75@email.android.com>
	<BANLkTi=bKG4b6ziSkCqEfgqJ3VmktwVc7A@mail.gmail.com>
Date: Sun, 26 Jun 2011 10:10:58 +0200
X-Google-Sender-Auth: Dq0sGlHpCko0M3JYIPD_ZL20pv4
Message-ID: <BANLkTikB3QTyd3Ue7N+w6V3xq1jqToAu2g@mail.gmail.com>
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

On Tue, May 31, 2011 at 21:34, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, May 31, 2011 at 13:01, jonathan.cameron@gmail.com
> <jic23@cam.ac.uk> wrote:
>> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>On m68k (which doesn't support generic hardirqs yet):
>
> [...]
>
>>>Hence IIO_TRIGGER should depend on GENERIC_HARDIRQS.
>>>But as IIO_TRIGGER and IIO_RING_BUFFER form a maze of dependencies and
>>>selects,
>>>just make the whole IIO subsystem depend on GENERIC_HARDIRQS.
>>>
>>>This dependency also covers !S390, so that one can be removed again.
>> Dratt  We talked about this and thought S390 was the only non generic hard irq left.  Should have played safe sorry!
>
> I hope s390 will be the only one soon ;-)
>
>>>Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>
> Thanks!

Ping? Still broken in -next (and linus, FWIM).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
