Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2J2PEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:04:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34740 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2J2PEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:04:50 -0400
MIME-Version: 1.0
In-Reply-To: <20121029030549.EF94F14603E7@linuxdev-32>
References: <20121029030549.EF94F14603E7@linuxdev-32>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Oct 2012 08:04:27 -0700
X-Google-Sender-Auth: dPH4x2CW_D8vGeAOpiC25IBysrY
Message-ID: <CA+55aFy-J-ywFhZGoBqO2ih6Hk1=hJfz2VQO8d0pZ2+V0_mpQw@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] UniCore32 update for v3.7-rc2
To: guanxuetao <guanxuetao@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 8:05 PM, guanxuetao <guanxuetao@mprc.pku.edu.cn> wrote:
>
>   git://github.com/gxt/linux.git unicore32

I *really* want people who use public hosting to tag their pull
request with a signed tag (and using a gpg key I can see signed by
people). I realize that getting a key signed can sometimes be
problematic depending on geography etc, and I don't know where you are
based.

For something like unicore32, I could be convinced to even accept a
key that isn't signed by people I recognize - even if it doesn't
necessarily show identity, it does show that the person who keeps
asking me to pull controls the same key over time. Not a very strong
guarantee, but it is at least a potential for identity.

           Linus
