Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427Ab2JDIQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:16:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2JDIQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:16:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] dma: tegra: fix interrupt name issue with apb dma.
Date: Thu, 4 Oct 2012 08:16:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Laxman Dewangan <ldewangan@nvidia.com>, arm@kernel.org, djbw@fb.com,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <1349284913-22350-1-git-send-email-ldewangan@nvidia.com> <506CA5D8.1050201@wwwdotorg.org>
In-Reply-To: <506CA5D8.1050201@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210040816.35500.arnd@arndb.de>
X-Provags-ID: V02:K0:m0ymirX87NxjfF6L77M25wGQd6b/HK9Uf26lUdmPwTS
 6JhIDG6WxgWNJVvt82blpEnTFZffYjw8gmQZBMUa++OnFxJf8y
 s+4u3ZWxeoa7cFk8zmXNBJ1nNIv+OewBbt0FRbWimh1r9B+CD5
 wWHMuNvkRgvT4si9GCJWBZGm1zVwQ+FFYF+Gytnu7HkxV0MYTR
 TD7FkeNaUjskfChkKwMuxp+qH9PzXPDIoFDjh0Kr0zzly349lS
 CSw7ZoM20bkwooTVRkm6xecfjKa53plSEEFWvW+b1d3z+PwrgO
 umb1TOacFH0kEd4HNvjg9IFJpGOE8vwG9dN2ahArQ4rS5CjkXE
 TFoqpMB4Jdm+vnC60T8I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2012, Stephen Warren wrote:
> On 10/03/2012 11:21 AM, Laxman Dewangan wrote:
> > When watching the interrupts through /proc/interrupts,
> > the name of the interrupts are blank or garbage. The
> > reason is the pointer passed for devname during irq
> > registration is stack and so it get changed after
> > dma registration completes.
> > Allocate the pointer as part of dma channel and pass
> > this pointer as the devname for irq registration to
> > avoid change of name.
> 
> (Dropping stable Cc; Olof/Arnd or Vinod, is it possible you could add
> that into the patch description when applying this?)
> 
> Reported-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>

Should be no problem. If Vinod wants to pick it up:

Acked-by: Arnd Bergmann <arnd@arndb.de>

Note that you can configure git send-email to automatically drop
Cc's to stable@vger.kernel.org, and that the correct address
is the one with vger in it, not just stable@kernel.org.
