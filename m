Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2EPGva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:51:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15087 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140Ab2EPGv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:51:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 15 May 2012 23:51:11 -0700
Date: Wed, 16 May 2012 09:51:07 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Glass <sjg@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: dt: tegra20.dtsi: Add Memory Controller(MC)
 nodes
Message-ID: <20120516095107.3510cb39d0f9cd2527e0bf1e@nvidia.com>
In-Reply-To: <CAOesGMiPvw72006zpSGLBNi-C12MTc_w2QmOPg6YTfXMW+ZSkQ@mail.gmail.com>
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
	<1336635764-30597-2-git-send-email-hdoyu@nvidia.com>
	<CAOesGMiPvw72006zpSGLBNi-C12MTc_w2QmOPg6YTfXMW+ZSkQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Wed, 16 May 2012 08:35:02 +0200
Olof Johansson <olof@lixom.net> wrote:

> Hi,
> 
> Tiny drive-by nit pick.
> 
> On Thu, May 10, 2012 at 12:42 AM, Hiroshi DOYU <hdoyu@nvidia.com> wrote:
> > Add Tegra MC(Memory Controller) nodes for tegra20.dtsi.
> >
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > ---
> >  arch/arm/boot/dts/tegra20.dtsi |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> > index 24129fb..548b42e 100644
> > --- a/arch/arm/boot/dts/tegra20.dtsi
> > +++ b/arch/arm/boot/dts/tegra20.dtsi
> > @@ -211,5 +211,12 @@
> >                compatible = "nvidia,tegra20-ahb";
> >                reg = <0x6000c004 0x10c>; /* AHB Arbitration + Gizmo Controller */
> >        };
> > +
> > +       mc {
> 
> It's common to use a more plain english name here, so
> "memory-controller" would be a good name.

Agree. Seems to be common as below. Fix patches follows, which can be squashed if possible.

$% grep memory-controller arch/arm/boot/dts/*
arch/arm/boot/dts/prima2-cb.dts:                        memory-controller@90000000 {
arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts:    memory-controller@2b0a0000 {
arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts:    memory-controller@7ffd0000 {
arch/arm/boot/dts/vexpress-v2p-ca5s.dts:        memory-controller@2a150000 {
arch/arm/boot/dts/vexpress-v2p-ca5s.dts:        memory-controller@2a190000 {
arch/arm/boot/dts/vexpress-v2p-ca9.dts: memory-controller@100e0000 {
arch/arm/boot/dts/vexpress-v2p-ca9.dts: memory-controller@100e1000 {
