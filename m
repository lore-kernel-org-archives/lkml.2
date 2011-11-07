Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1KGHAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 02:00:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37397 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1KGHAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 02:00:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
Date: Mon, 7 Nov 2011 09:00:05 +0200
X-Google-Sender-Auth: tWdl9KDuEUpd3EGobu0SMqKqsPA
Message-ID: <CAOJsxLGH6maRZPx0TX4r6Zy=AiXQMRssoySeOmjn02O-BkBDEA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] x86: check stack overflows more reliably
From: Pekka Enberg <penberg@kernel.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 7:51 AM, Mitsuo Hayasaka
<mitsuo.hayasaka.hu@hitachi.com> wrote:
> (2) check stack overflow in detail
>    Currently, only kernel stack is checked for the overflow,
>    which is not sufficient for enterprise systems. To enhance
>    reliability, expand stack overflow checking to IRQ and
>    exception stacks optionally. This is disabled by default
>    in Kconfig.

This sounds useful. What's the reason for not enabling this by
default? Performance regressions?

                        Pekka
