Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab2IXRCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:02:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56302 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2IXRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:02:42 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <20120924192154.2aab0ae61dea89722bbcb974@canb.auug.org.au>
References: <20120924192154.2aab0ae61dea89722bbcb974@canb.auug.org.au>
Date: Mon, 24 Sep 2012 10:02:40 -0700
Message-ID: <CAOesGMgP0rSXBruLNtqfOEzPAbRdbfOmEa4K+qZ++4GzZ4yNXw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pm tree
From: Olof Johansson <olof@lixom.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 24, 2012 at 2:21 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-shmobile/include/mach/common.h between commit 35f2b0bd5911
> ("ARM: shmobile: Move definition of shmobile_init_late() to header") from
> the pm tree and commit a62580e58065 ("ARM: SoC: convert shmobile SMP to
> SMP operations") from the arm-soc tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Hmm.

Rafael, the shmobile SoC-specific code in your tree looks like it
should have been merged through arm-soc? That way we could have
resolved the conflicts locally without having it spill out into other
trees (and thus seen by both sfr and Linus when the branches goes up
to him).


-Olof
