Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1L2Exd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 23:53:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38879 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1L2Exa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 23:53:30 -0500
MIME-Version: 1.0
In-Reply-To: <4EFB2B8A.9010902@gmail.com>
References: <4EFB2B8A.9010902@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 28 Dec 2011 21:53:08 -0700
X-Google-Sender-Auth: rUNm1UhmqgSQwb1QNoeoUq9-4qw
Message-ID: <CACxGe6tM9dGGccUhhOEsah+8P=1XjYVh=KXy8J+V0pVVdoZrDA@mail.gmail.com>
Subject: Re: [PULL] Devicetree for 3.3
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged, thanks.

g.

On Wed, Dec 28, 2011 at 7:45 AM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> Please pull device tree updates for 3.3. Pretty much a random collection
> of minor changes. I'm including i2c-designware DT binding support here
> as I've gotten no response from Ben.
>
> Rob
>
> The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:
>
>  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)
>
> are available in the git repository at:
>  git://sources.calxeda.com/kernel/linux.git for-grant
>
> Benoit Cousson (1):
>      of/base: Take NULL string into account for property with multiple
> strings
>
> David Daney (1):
>      OF/device-tree: Add some entries to vendor-prefixes.txt
>
> Dong Aisheng (1):
>      dt: reform for_each_property to for_each_property_of_node
>
> Olof Johansson (1):
>      dt/i2c: Enumerate some of the known trivial i2c devices
>
> Rob Herring (3):
>      i2c-designware: add OF binding support
>      dt: add empty of_get_node/of_put_node functions
>      irq: check domain hwirq range for DT translate
>
> Sam Ravnborg (1):
>      of/pdt: fix section mismatch warning
>
> Uwe Kleine-König (1):
>      ARM/of: allow *machine_desc.dt_compat to be const
>
>  .../devicetree/bindings/i2c/i2c-designware.txt     |   22 ++++++++
>  .../devicetree/bindings/i2c/trivial-devices.txt    |   58
> ++++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |    3 +
>  arch/arm/include/asm/mach/arch.h                   |    2 +-
>  drivers/i2c/busses/i2c-designware-platdrv.c        |   12 ++++
>  drivers/of/base.c                                  |   10 ++--
>  drivers/of/fdt.c                                   |    4 +-
>  drivers/of/pdt.c                                   |    2 +-
>  include/linux/of.h                                 |   33 ++++++------
>  include/linux/of_fdt.h                             |    4 +-
>  kernel/irq/irqdomain.c                             |    3 +
>  11 files changed, 124 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-designware.txt
>  create mode 100644
> Documentation/devicetree/bindings/i2c/trivial-devices.txt



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
