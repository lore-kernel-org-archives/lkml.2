Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1IUJbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:31:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55926 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1IUJbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110921103329.c24fb7e8c8b34217c38f92b2@canb.auug.org.au>
References: <20110921103329.c24fb7e8c8b34217c38f92b2@canb.auug.org.au>
Date: Wed, 21 Sep 2011 11:31:15 +0200
Message-ID: <CACRpkdbaw1k6kTMYCRur55NwuE56ABFCw10ahi8gQ582ZoSfYg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 2:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the arm tree got a conflict in
> arch/arm/mach-integrator/integrator_ap.c between commit b71d8429ec36
> ("mach-integrator: fix VGA base regression") from Linus' tree and commit
> b79573586838 ("ARM: 7087/2: mach-integrator: get timer frequency from
> clock") from the arm tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

The fix is correct, thanks Stephen.

Yours,
Linus Walleij
