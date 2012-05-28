Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2E1Mrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:47:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62601 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2E1Mro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:47:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120524013001.A465B7C007A@ra.kernel.org>
References: <20120524013001.A465B7C007A@ra.kernel.org>
Date: Mon, 28 May 2012 14:47:43 +0200
X-Google-Sender-Auth: jJxAK8Jcg6cKOu9IOMHHH_n0irg
Message-ID: <CAMuHMdWwX+iwy87dsTsSgsA=w5qJbeLUo39SixpqtaPkZ-Sprw@mail.gmail.com>
Subject: Re: userns: Add negative depends on entries to avoid building code
 that is userns unsafe
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 3:30 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> +config UIDGID_CONVERTED
> +       # True if all of the selected software conmponents are known

components

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
