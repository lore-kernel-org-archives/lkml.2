Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1EGI1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:27:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1EGI1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Z3nnXOIjpNOMBaGgAgXvNmOLhJS55ah1uRMN3yBExk33GbuN749dswTAFqT8njdaPP
         7vi9YRRkpAU0H9W1fy+nNykxY1sAU1gRFllPVQbuzwOX3YF0yz8JwNVlt8FGr75pJ4fr
         I/fChPKpQK7UKW5Y+RID1tXVbhSHnkaLFvtGA=
MIME-Version: 1.0
In-Reply-To: <1304735101-1824-7-git-send-email-ebiederm@xmission.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<1304735101-1824-1-git-send-email-ebiederm@xmission.com>
	<1304735101-1824-7-git-send-email-ebiederm@xmission.com>
Date: Sat, 7 May 2011 10:27:17 +0200
X-Google-Sender-Auth: 5pMbtnqV1au3lnx9sxDZFgePrgg
Message-ID: <BANLkTi=G-uViB6=8bQ0dRGbw3Gg8V10CRw@mail.gmail.com>
Subject: Re: [PATCH 7/7] ns: Wire up the setns system call
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 04:25, Eric W. Biederman <ebiederm@xmission.com> wrote:
>  arch/m68k/include/asm/unistd.h         |    3 ++-
>  arch/m68k/kernel/syscalltable.S        |    1 +

As the unified syscalltable for m68k/m68knommu is not yet in mainline
(planned for
2.6.40), you should also add it to arch/m68k/kernel/entry_mm.S.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
