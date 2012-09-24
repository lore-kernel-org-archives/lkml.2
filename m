Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2IXPBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:01:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2IXPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:01:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v3 1/1] arm: introduce a DTS for Xen unprivileged virtual machines
Date: Mon, 24 Sep 2012 15:00:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ian.Campbell@citrix.com,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        pawel.moll@arm.com, linux-arm-kernel@lists.infradead.org
References: <1348483574-7901-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1348483574-7901-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209241500.53229.arnd@arndb.de>
X-Provags-ID: V02:K0:KywjuGhwIJhHacMinUJ6ph/V3TXSz5eNVIKWmsvbtM6
 bllL136C0diKbX5YBSTY88cK4nHWGS9+poOlmpV//jfnAVF8Hy
 cNSB9Y0RgLrcbnQaNLnmuXOTthuefuxYBIU8HRW9e/VTAY4wPU
 v0HYiycWfR4QwXlyIkJ7bpBoina/UA46SVvAZy9N8f1qS525X1
 SdU4UrpBcQ+WnP422cJh8K/rVnazYoZ1tYYNUTEuwI29D/1tEX
 4GO/4kHvQOs1wmWGIgv8TQ4tcXr+Th0QqOttxPnkEQ8cnrZFTi
 yq6z6bbrwalgBb+nt21XGfEXqbrEl1jZmlisfOBblHUD5pGqg4
 2TxY4HLWgAs7Ln9HwzEA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2012, Stefano Stabellini wrote:
> Given that the xenvm machine is based on vexpress but with an extremely
> limited selection of peripherals (the guest is supposed to use virtual
> devices instead), add "xen,xenvm" to the list of compatible machines in
> mach-vexpress.
> 
> 
> Changes in v3:
> 
> - add comments to mark fields that are likely to be changed by the
> hypervisor.
> 
> 
> Changes in v2:
> 
> - remove include skeleton;
> - use #address-cells = <2> and #size-cells = <2>;
> - remove the debug bootargs;
> - use memory@80000000 instead of memory;
> - remove the ranges and interrupt-map from the motherboard node;
> - set the machine compatible to "xen,xenvm-4.2", "xen,xenvm";
> - rename the dts file to xenvm-4.2.dts;
> - add "xen,xenvm" to the list of compatible DT strings to mach-vexpress.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Pawel Moll <pawel.moll@arm.com> (v2m changes)
> CC: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
