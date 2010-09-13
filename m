Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0IMSOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:14:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61253 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0IMSOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a5qgrgaW9fPF2mQ2u6FCNlv3lSlqmAAIwoIYhjp5fBSbg31usl4uC9JLdKlUxZVPVe
         FRzxaTznUEMkLht/SM2k6RSUHC3dMzXr1TcyJRfSAf55ekjq+mjaJQOFwlXdfzdQcBoA
         Qwn5kVvKI4+zmXRHIzx0zMJgxeAVH8j0D8LgA=
MIME-Version: 1.0
In-Reply-To: <86fd3a30b5cce0a637243e822e96f5bc76269670.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<86fd3a30b5cce0a637243e822e96f5bc76269670.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
Date: Mon, 13 Sep 2010 20:14:01 +0200
X-Google-Sender-Auth: 3RnqrSObErF2u6f4m6OA3_OdYas
Message-ID: <AANLkTin=DKXUddwqxRP-iXhaYptc=ounfN88O5R8OShk@mail.gmail.com>
Subject: Re: [PATCH 3/9] arch/m68k{,nommu}: Removing dead SMP config option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Roman Zippel <zippel@linux-m68k.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Sam Creasey <sammy@sammy.net>,
        Greg Ungerer <gerg@uclinux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Joe Perches <joe@perches.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 14:41, Christian Dietrich
<qy03fugy@stud.informatik.uni-erlangen.de> wrote:
> CONFIG_SMP doesn't exist in Kconfig (for this architecure), therefore
> removing all references to it from the source.
>
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Applied

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
