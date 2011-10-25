Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1JYHii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:38:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45557 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1JYHih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110242118500.9114@ayla.of.borg>
References: <alpine.DEB.2.00.1110242118500.9114@ayla.of.borg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 09:38:15 +0200
X-Google-Sender-Auth: kESfZXmNq48JG5zV-mcNBeuQlNQ
Message-ID: <CA+55aFxK-OJXDNsJ37wSN+MGhGp-j50BX-52eEjBHVSepTTm9w@mail.gmail.com>
Subject: Re: [git pull] m68k updates for 3.2
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>, Greg Ungerer <gerg@snapgear.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 9:26 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
>  git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Please fix your pull script. There's an extraneous ":" there. Spot it?

Also, while I see these commits in linux-next, I also see that they
have been rebased in the last day, which means that looking for them
in linux-next is actually much harder than they need to be.

In other words - WHY DID YOU REBASE? It just generates more work for
me, and adds absolutely zero value.

I pulled it, but some of the silly details annoyed me.

             Linus
