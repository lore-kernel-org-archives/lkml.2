Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1DMSLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:11:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45944 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1DMSLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MJG+nAEpVfZ1NRxRV2bEz5cORRNklMJZFcat4vIacFiaMxgQL4SwU4+52LbqZuF/NV
         jON2OY5W741oIDtni6QgRSFAABXuP+DzUfmKGGrC9/s1PuXWyc+/+lBaYKRx9InFEwiK
         +V9VPt6cuvaFZfCB0mQlEEK9MFVrbVdrTfv04=
MIME-Version: 1.0
In-Reply-To: <4da5e1dc16852d7b29@agluck-desktop.sc.intel.com>
References: <20110413103109.76b9bb3d.rdunlap@xenotime.net>
	<4da5e1dc16852d7b29@agluck-desktop.sc.intel.com>
Date: Wed, 13 Apr 2011 20:11:10 +0200
X-Google-Sender-Auth: 3wRGZXI25EuqSLcd7XXz2sofp8g
Message-ID: <BANLkTinfLDGJv14LiZFFabJNEnXJ_8niXQ@mail.gmail.com>
Subject: Re: [PATCH] Fix Kconfig dependencies for apei->pstore
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: len.brown@intel.com, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 19:48, Luck, Tony <tony.luck@intel.com> wrote:
> Geert Uytterhoeven's dependency checker kicked out this warning:

Na, it's not mine. Just the standard one of the Linux build system.
All I do is run a script on the logs from the linux-next build service.

> + warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies (MISC_FILESYSTEMS):  => N/A
>
> Randy confirmed that the fix was to "select MISC_FILESYSTEMS" too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
