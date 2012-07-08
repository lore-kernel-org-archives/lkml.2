Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2GHUbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 16:31:24 -0400
Received: from seven.medozas.de ([5.9.24.206]:58116 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2GHUbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 16:31:23 -0400
Date: Sun, 8 Jul 2012 22:31:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Jon Masters <jcm@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
In-Reply-To: <4FF93C99.80203@redhat.com>
Message-ID: <alpine.LNX.2.01.1207082229020.22454@frira.zrqbmnf.qr>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <4FF93C99.80203@redhat.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2012-07-08 09:54, Jon Masters wrote:
>
>FWIW I actually really like the aarch64 name (but you know that already
>:) ). I think it clearly spells out that this is not just a 64-bit
>extension to the existing 32-bit ARM Architecture, it is a new (inspired
>by ARM) architecture.

IA64 also has a "arch" inside, and look where it took them.
(The contemporary platform winner came to be x86_64 instead
of what Intel had hoped back then.)
