Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2AWEYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 23:24:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58503 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2AWEYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 23:24:17 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120123120933.6d4c9cc7050fce2e9fbc9d3a@canb.auug.org.au>
References: <20120123120933.6d4c9cc7050fce2e9fbc9d3a@canb.auug.org.au>
Date: Sun, 22 Jan 2012 20:24:16 -0800
Message-ID: <CAOesGMgH0owngSkJq72Wf01Z7YSsD9pzRZWtzSvZt+Q7ZA6qng@mail.gmail.com>
Subject: Re: linux-next: manual merge of the crypto tree with the tegra tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Henning Heinold <heinold@inf.fu-berlin.de>,
        Varun Wadekar <vwadekar@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012 at 5:09 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Herbert,
>
> Today's linux-next merge of the crypto tree got a conflict in
> arch/arm/mach-tegra/fuse.c between commit b2609c7c7237 ("ARM: tegra:
> fuse: add functions to access chip revision") from the tegra tree and
> commit e87e06cd8cc0 ("arm: tegra: export tegra_chip_uid") from the crypto
> tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

I should cherry-pick in the same change as Herbert is carrying, and do
the rest of the fuse changes on top of that. I'll do that for
tomorrows -next.



-Olof
