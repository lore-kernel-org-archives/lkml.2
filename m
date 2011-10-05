Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935058Ab1JEQxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:53:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62273 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab1JEQxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <4E8C88A1.4090308@gmail.com>
References: <4E8C88A1.4090308@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 5 Oct 2011 10:53:23 -0600
X-Google-Sender-Auth: p_lCVMJBbjzzT3PUE18fKJogRrY
Message-ID: <CACxGe6siwgLK0PA3Xtfkzyz4opf-ox4Vid0PQY7EUQMw_3DtMw@mail.gmail.com>
Subject: Re: [PULL] Devicetree for 3.2
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 10:41 AM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> Please pull for 3.2. These commits don't have any dependencies and are
> not dependencies for me, so they don't need to go in thru arm-soc.
>
> Rob
>
> The following changes since commit 976d167615b64e14bc1491ca51d424e2ba9a5e84:
>
>  Linux 3.1-rc9 (2011-10-04 18:11:50 -0700)
>
> are available in the git repository at:
>  git://git.jdl.com/software/linux-3.0.git for-grant
>
> Rob Herring (4):
>      MAINTAINERS: update devicetree maintainers
>      of/irq: of_irq_find_parent: check for parent equal to child
>      devicetree: Add ARM pl061 gpio controller binding doc
>      devicetree: Add ARM pl022 spi controller binding doc

Pulled thanks.

Nit: the of_irq_find_parent patch really should have my acked-by, and
I had hoped to get Ben's too.  (though I did only say "looks good"
without explicitly write an a-b in my reply, so did leave ambiguity).
We *might* end up having to revert that one if it causes problems in
powerpc-land.

g.

>
>  .../devicetree/bindings/gpio/pl061-gpio.txt        |   10 ++++++++++
>  .../devicetree/bindings/spi/spi_pl022.txt          |   12 ++++++++++++
>  MAINTAINERS                                        |    2 ++
>  drivers/of/irq.c                                   |   14 +++++++-------
>  4 files changed, 31 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/pl061-gpio.txt
>  create mode 100644 Documentation/devicetree/bindings/spi/spi_pl022.txt
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
