Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2IUQkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:40:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62811 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2IUQj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:39:59 -0400
MIME-Version: 1.0
In-Reply-To: <201209211449.56906.arnd@arndb.de>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
	<CAOMZO5C2ihKUeQk17JOHc9VXAB3KTeQLS3OcLOiiUC8jucsexg@mail.gmail.com>
	<CAOMZO5C2rTBM6si0MUC7XWznwqwmUq5-LmFyekLab8UBVwaCFw@mail.gmail.com>
	<201209211449.56906.arnd@arndb.de>
Date: Fri, 21 Sep 2012 13:39:59 -0300
Message-ID: <CAOMZO5DwwxFz30hHVyUWPBwEzCD+qcoxE6ef3t758MHd72JdKw@mail.gmail.com>
Subject: Re: [PATCH 01/11] ARM: defconfig: Remove CONFIG_MISC_DEVICES
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Sep 21, 2012 at 11:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> Sorry for not replying earlier. We could merge these through the
> arm-soc tree, but I'm not actually sure if they are necessary.
>
> For all I know, listing a nonexisting configuration option in
> a defconfig file has no effect, and the files get recreated
> whenever the maintainers choose to.

My intention with this series is merely to provide a cleanup in the
defconfigs, so that they do not include an non-existing configuration.
I know it is not harmful to let the CONFIG_MISC_DEVICES there, but
after my commit 7c5763 I think we should get rid of
CONFIG_MISC_DEVICES completely.

I saw that the ia64 Intel patch from this series was already applied
into mainline and I also got some other Acks from different
architectures.

Regards,

Fabio Estevam
