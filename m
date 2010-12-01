Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0LAVaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 16:30:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59467 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab0LAVao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 16:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=gswveuCTuQF9KeUafAO/hcRN0Hr131iondjdceV7SUoChm5FWJszyGi65WP4xxas2R
         z+Ezg31kXoKIKETqwAaL0ItRkWlTUen9JU//b7u6lZTpmq3bNiSg6sbaOgk6FusncWPF
         Fr7Uoef0YeHmtaK87SzsrrlgQv0kGlpDCPsHc=
MIME-Version: 1.0
Date: Wed, 1 Dec 2010 22:30:43 +0100
X-Google-Sender-Auth: S-3F0hRR34L8WMC28ePUqid4u4Q
Message-ID: <AANLkTikpZMV3tZNgfwQPGh41ktVVL6ptGhK-1BJB2ER5@mail.gmail.com>
Subject: Build regressions/improvements in v2.6.37-rc4 (was: Re: Build
 regressions/improvements in v2.6.37-rc3)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bummer, v2.6.37-rc4, of course.
I should start scripting the full report, too...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
