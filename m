Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0GLVPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:15:05 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:52158 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab0GLVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:15:02 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net A0644107B09
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH] x86: Setup early console as early as possible
To: "H.  Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Mon, 12 Jul 2010 22:57:18 +0200
References: <f5czp-42V-9@gated-at.bofh.it> <f5n1M-2lt-21@gated-at.bofh.it> <f5tqz-3ll-37@gated-at.bofh.it> <f5u3g-4mj-11@gated-at.bofh.it> <f5v90-5Wo-7@gated-at.bofh.it>
User-Agent: KNode/4.3.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
Message-Id: <20100712211459.A0644107B09@mail-in-07.arcor-online.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/12/2010 09:21 AM, Yinghai Lu wrote:

>> earlycon=uart8250 or console=uart8250 should be better than earlyprintk.
>> because it is shared between different archs already.

> console= is crap, because it makes the user keep track of items they
> should not have to deal with directly (unless they want to override the
> defaults), i.e. the specific I/O ports used by the serial ports.

Why does console= require these parameters, if earlyprintk does not?

IMO you should fix console= to not need these parameters unless they cannot
be guessed (in which case earlyprintk cannot guess them, either).

¢¢
