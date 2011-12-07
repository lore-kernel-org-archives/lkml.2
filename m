Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1LGC5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:57:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61777 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1LGC52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:57:28 -0500
MIME-Version: 1.0
In-Reply-To: <20111207105252.25156be522cc26b520eac8f0@canb.auug.org.au>
References: <20111207105252.25156be522cc26b520eac8f0@canb.auug.org.au>
Date: Wed, 7 Dec 2011 10:57:27 +0800
Message-ID: <CAAQ0ZWRQVTdPyp+_9da0kAEv8aYEL2MafA=qz0YOBWmWhfba0g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Lauri Hintsala <lauri.hintsala@bluegiga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 7 December 2011 07:52, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Arnd,
>
> Today's linux-next merge of the arm-soc tree got conflicts in
> arch/arm/mach-mxs/mach-m28evk.c and
> arch/arm/mach-mxs/mach-stmp378x_devb.c between commit d4e717535e94 ("ARM:
> restart: mxs: use new restart hook") from the arm tree and commit
> 8d2d2d1d7e96 ("ARM: mxs: fix machines' initializers order") from the
> arm-soc tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

The fix looks right.

Regards,
Shawn
