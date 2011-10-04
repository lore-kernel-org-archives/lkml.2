Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab1JDTeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:34:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130Ab1JDTeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:34:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Date: Tue, 04 Oct 2011 21:33:48 +0200
Message-ID: <14177423.bqmiv1UdlY@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173A2C6F74@HQMAIL01.nvidia.com>
References: <20111004110831.a4d6d72a9b75a38265c9d6a1@canb.auug.org.au> <74CDBE0F657A3D45AFBB94109FB122FF173A2C6F74@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2VHSTU78KCW9W4+RIQVgCyz5rTih21hhqZzjn0wLI+9
 IpxcY2+QLR2e2ca20MvA/Iw2OhI5eDvUKJ8eKGgMrAh2g8dsbG
 h0FfoIQko4XjB8EDHSutx9+NzjAMCvDkzQt7QHLbYry4MjW7TV
 atyqyRQN1RR0JTcevukzxQsDf/tnsbeLckZ0M99+AfwIIiVX1G
 AWfClhGYE1ESkJcaeRGo4xqG82OBGYI//9P+CaJafH/hZfX3vj
 I9tAM7f2KvpB0orts0SdathxCjUOOtIeU28ncp+HBoqBEeMaFU
 8z0w2F+/E4y/aynR3nneImLGmZKvzkOhrhTkLTgX5sM9MrDTp9
 GABDc4498dqOt2ZS3JhY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011 08:48:33 Stephen Warren wrote:
> Stephen Rothwell wrote at Monday, October 03, 2011 6:09 PM:
> > Hi Arnd,
> > 
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-tegra/board-seaboard.h between commit ea5abbd215b7 ("ARM:
> > 7101/1: arm/tegra: Replace <mach/gpio.h> with <mach/gpio-tegra.h>") from
> > the arm tree and commit a697e694aeb8 ("ARM: Tegra: Seaboard board updates
> > for audio") from the arm-soc tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.
> 
> Both this and the similar fixup in the other email look fine to me.
> 
> For my education, how does this get resolved; presumably neither Russell's
> tree nor arm-soc can take a patch that fixes this right now, so does one of
> the trees get rebased after the merge of the other but before being pulled
> by Linus, or does Linus do this merge fixup when he pulls?
> 
> Thanks for cluing me in!

Stephen resolves it using git rerere for now, which automatically remembers
the fix. When I start sending patches to Linus, I have the choice to
either do the fixup myself or let Linus do it.

Linus generally wants to see the conflicts and fix them on his own, so that
is the default. If there are complicated merges, I provide another branch
that has the solution so he can compare it with the solution he came up with,
or just take it.

Last time, there was one pull request I sent to Linus that had lots of trivial
conflicts with another branch that I also sent him. Given the same situation,
I would probably just do the merge before I send the pull request.

	Arnd
