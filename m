Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0GHQtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:49:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18377 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0GHQtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:49:53 -0400
Date: Thu, 8 Jul 2010 09:48:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, David Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for July 8 (nouveau)
Message-Id: <20100708094842.2753a194.randy.dunlap@oracle.com>
In-Reply-To: <20100708151022.d2517577.sfr@canb.auug.org.au>
References: <20100708151022.d2517577.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C3601A9.002D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 15:10:22 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100707:
> 
> The i.MX tree mismerge has been fixed.
> 
> The omap tree gained a conflict (involving serveral files) against the
> arm tree.
> 
> ----------------------------------------------------------------------------


Should nouveau depend on PCI?
It has build errors when PCI is disabled:

drivers/gpu/drm/nouveau/nouveau_bios.c: In function 'load_vbios_pci':
drivers/gpu/drm/nouveau/nouveau_bios.c:167: error: implicit declaration of function 'pci_enable_rom'
drivers/gpu/drm/nouveau/nouveau_bios.c:171: error: implicit declaration of function 'pci_map_rom'
drivers/gpu/drm/nouveau/nouveau_bios.c:171: warning: assignment makes pointer from integer without a cast
drivers/gpu/drm/nouveau/nouveau_bios.c:175: error: implicit declaration of function 'pci_unmap_rom'
drivers/gpu/drm/nouveau/nouveau_bios.c:178: error: implicit declaration of function 'pci_disable_rom'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
