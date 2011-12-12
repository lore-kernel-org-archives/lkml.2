Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1LLQvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:51:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35184 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1LLQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:51:14 -0500
MIME-Version: 1.0
In-Reply-To: <86sjkpiw8i.fsf@sumi.keithp.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
 <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com>
 <8639cqjvyn.fsf@sumi.keithp.com> <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
 <86sjkpiw8i.fsf@sumi.keithp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Dec 2011 08:50:52 -0800
X-Google-Sender-Auth: ddKiwDlk3SOZV-r7drDc6TCtTs4
Message-ID: <CA+55aFzkq-3z3URp75LkVd=Qk1nEk76wDZCrLPKyabNcdieQVA@mail.gmail.com>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
To: Keith Packard <keithp@keithp.com>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 8:35 AM, Keith Packard <keithp@keithp.com> wrote:
>
> Happy to oblige. Here's the first few seconds (until X starts):

Ahh. And the reason it works for me is that I don't even have
"CONFIG_EFI" enabled, much less EFI debugging. So I never trigger the
buggy code at all.

That certainly explains why I never saw the problem,

                 Linus
