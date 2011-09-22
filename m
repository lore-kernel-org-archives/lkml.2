Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1IVUCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:02:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43713 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1IVUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109222140510.8856@ayla.of.borg>
References: <alpine.DEB.2.00.1109222140510.8856@ayla.of.borg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Sep 2011 13:01:55 -0700
X-Google-Sender-Auth: gM_WYKTg1nSLwws3Ubm42n9UikE
Message-ID: <CA+55aFxm86xohU4nSuDWe_Ru9SU79x1sLHNdm4nFHyJNH4=mBQ@mail.gmail.com>
Subject: Re: [PATCH] zorro: Defer device_register() until all devices have
 been identified
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2011.bluespice.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 12:47 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Authorization code F68KAMYRULEZ.

EUNAUTHORIZED.

But applied anyway,

                Linus
