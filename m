Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1LGC7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:59:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34440 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab1LGC7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:59:08 -0500
MIME-Version: 1.0
In-Reply-To: <20111207105314.3afd16489c0304e2eae7a71d@canb.auug.org.au>
References: <20111207105314.3afd16489c0304e2eae7a71d@canb.auug.org.au>
Date: Wed, 7 Dec 2011 10:59:06 +0800
Message-ID: <CAAQ0ZWS80uirq3GRFRmVwSf+-MEgWgu9fUsU+J+bWKqbQW3V-w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Dong Aisheng <b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 7 December 2011 07:53, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Arnd,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-mxs/include/mach/common.h between commit d4e717535e94
> ("ARM: restart: mxs: use new restart hook") from the arm tree and commit
> 4e1b4ecaa231 ("ARM: mxs: add saif clkmux functions") from the arm-soc
> tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

The fix looks right.

Regards,
Shawn
