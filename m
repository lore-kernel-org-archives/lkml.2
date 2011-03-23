Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab1CWUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:31:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36338 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab1CWUbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SyJUm4suAQkfVsEB2aSprCz2GV2HMLWMIWWmt848RMms8hmHtNtfZxdD0SeVRDufqF
         bmwx2E7EM6gInQ9IrHabGTBD5ARCCqebA4/GkWnYvDUaLa0OKbI5xGPuRQUafGAYpFwy
         PfM0y3z2mA8QRFLrAR07Pf0k9GEFEiSmzIdk0=
MIME-Version: 1.0
In-Reply-To: <201103230200.p2N20nBv011302@hera.kernel.org>
References: <201103230200.p2N20nBv011302@hera.kernel.org>
Date: Wed, 23 Mar 2011 21:31:28 +0100
X-Google-Sender-Auth: bMQAoFOKDTdI-tfxYbUFZ_sBLv0
Message-ID: <AANLkTi=JuHke7CMURU6fuBSVenD1prHfKRTqJucr0g9o@mail.gmail.com>
Subject: Re: kstrto*: converting strings to integers done (hopefully) right
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 03:00, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> --- /dev/null
> +++ b/lib/test-kstrtox.c

On 32-bit m68k:

lib/test-kstrtox.c: In function ‘test_kstrtou64_ok’:
lib/test-kstrtox.c:318: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:319: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:320: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:321: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:322: warning: integer constant is too large for ‘long’ type
lib/test-kstrtox.c:323: warning: integer constant is too large for ‘long’ type
lib/test-kstrtox.c: In function ‘test_kstrtos64_ok’:
lib/test-kstrtox.c:372: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:373: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:374: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:375: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:376: warning: integer constant is too large for ‘long’ type
lib/test-kstrtox.c:377: warning: integer constant is too large for ‘long’ type
lib/test-kstrtox.c: In function ‘test_kstrtou32_ok’:
lib/test-kstrtox.c:421: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:422: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:423: warning: this decimal constant is unsigned
only in ISO C90
lib/test-kstrtox.c:424: warning: this decimal constant is unsigned
only in ISO C90

Probably you need a few more U/ULL suffixes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
