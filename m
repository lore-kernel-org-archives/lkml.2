Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189Ab2EXUDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:03:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42292 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965438Ab2EXUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:03:05 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 24 May 2012 14:02:44 -0600
X-Google-Sender-Auth: x4dS1mOnJMFeglHjHKS1cuo-HJQ
Message-ID: <CACxGe6sTLbNoVN79iayrZ24oaHHnS4jdiOwFVVXWNdeFdp87MA@mail.gmail.com>
Subject: [GIT PULL] devicetree changes for v3.5 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Description below, please pull.
g.

The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/devicetree-for-linus

for you to fetch changes up to 8d6c1efa51236bb781f202aa13b9f4ba654978c6:

  Merge branch 'devicetree/merge' into devicetree/next (2012-05-20
20:18:37 -0600)

----------------------------------------------------------------

Device tree changes for v3.5 merge window

Mostly documentation updates, but also includes an empty stub for
non-CONFIG_OF builds.

----------------------------------------------------------------
Grant Likely (1):
      Merge branch 'devicetree/merge' into devicetree/next

Marc Zyngier (1):
      ARM: DT: Add binding for GIC virtualization extentions (VGIC)

Roland Stigge (1):
      dt/documentation: Fix value format description

Stephen Warren (1):
      dt: add vendor prefix for EM Microelectronics

Thomas Abraham (1):
      of/irq: add empty irq_of_parse_and_map() for non-dt builds

 Documentation/devicetree/bindings/arm/gic.txt      |   35 ++++++++++++-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/devicetree/booting-without-of.txt    |   55 ++++++++++----------
 include/linux/of_irq.h                             |   12 ++++-
 4 files changed, 72 insertions(+), 31 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
