Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2IJOvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:51:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2IJOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:50:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Date: Mon, 10 Sep 2012 14:48:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <201209101353.34325.arnd@arndb.de> <alpine.LFD.2.02.1209101007160.28681@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1209101007160.28681@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101448.20745.arnd@arndb.de>
X-Provags-ID: V02:K0:mbFtyC3So4zSz3YpoVZDy862LbMZ2XDRwy1gjN6/jhT
 Achq/F8uWq+3Pmv+aWbLa4gYZaRGeJ54Df4K6tfVlux93wJ0B1
 NcBSa04x/+4yvKjTPV5HVJ6HQpXYrRJ3R2O+N8K1DvqbmmLHGB
 yqlryhnW+CwgKISunwYe8p7WnNIab69mitUz+Yt/jr7IIzM7wF
 zUU+lYw/CRy0Kpr0WVAccrnDP+rQkcYItGnWYJmlB0in00qkL7
 ogRegTEcOo8F0HfEd0/7C6HpL8Dq5KvNk4mN9CrzUdN/n0KJzX
 Om7vdrH6xfVNrH1x0oGn0faVsgenCTHQPoZ+jC99f5/xJPFsiV
 i1MaTqkWIYyqOYGUEz7w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Nicolas Pitre wrote:
> On Mon, 10 Sep 2012, Arnd Bergmann wrote:
> > On Monday 10 September 2012, Catalin Marinas wrote:
> > > On Mon, Sep 10, 2012 at 06:53:39AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > I think a bunch of other architectures can have relocatable kernels, which
> > is useful e.g. for kdump. It does imply a small runtime cost and may have
> > other disadvantages though.
> 
> Relocatable in physical space is what kdump actually needs, and that's 
> what we already have here (as well as on ARM32 for that matter with 
> CONFIG_ARM_PATCH_PHYS_VIRT).  Relocatable in the virtual space is costly 
> and we shouldn't need to go there.

Ah, I see. I thought that the other architectures (powerpc and x86)
doing this were actually building with -fPIC, but they do the same
kind of early patching that we do.

	Arnd
