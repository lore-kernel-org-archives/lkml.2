Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab2EVCOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:14:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42426 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab2EVCOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzYd9b4CF30vK+rT_daKLXKBd7kOpsOZtoPKcDnsgYAxA@mail.gmail.com>
References: <20120522011152.GA18115@redhat.com> <20120522013949.GA31883@redhat.com>
 <CA+55aFzYd9b4CF30vK+rT_daKLXKBd7kOpsOZtoPKcDnsgYAxA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 19:14:32 -0700
X-Google-Sender-Auth: K_6vs54I8yupYbds3wzv05F2K4Q
Message-ID: <CA+55aFwd9DGhUeMGqRxYm2qgENPCjChTDFK6G-mkNMp+WUKtdw@mail.gmail.com>
Subject: Re: 3.4+ dcache BUG.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 6:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm going to assume it's the exact same thing (and thus hopefully
> fixed by the revert that I just pushed out)

Oops. Except I hadn't actually pushed after committing.

NOW it's pushed out.

And please do a "git fetch --tags" too to make sure you have the tags,
and your "git describe" gives better output than
v3.3-rc7-<some-huge-number> ;)

                Linus
