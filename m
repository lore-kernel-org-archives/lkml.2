Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0CYUeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:34:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0CYUeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:34:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: maciej.rutecki@gmail.com
Subject: Re: [Regresion] [2.6.34-rc1] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Date: Thu, 25 Mar 2010 21:37:12 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       bjorn.helgaas@hp.com, airlied@linux.ie, Eric Anholt <eric@anholt.net>
References: <201003252104.24965.maciej.rutecki@gmail.com>
In-Reply-To: <201003252104.24965.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252137.12278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[More CCs]

On Thursday 25 March 2010, Maciej Rutecki wrote:
> Last known good: 2.6.33
> Failing kernels: 2.6.34-rc1 and 2.6.34-rc2
> Driver: Video(DRI - Intel)
> 
> 
> When XWindow starts I got:
> Mar 25 19:58:10 gumis kernel: [  133.624028] [drm:i915_hangcheck_elapsed] 
> *ERROR* Hangcheck timer elapsed... GPU hung
> Mar 25 19:58:10 gumis kernel: [  133.624221] render error detected, EIR: 
> 0x00000000
> Mar 25 19:58:10 gumis kernel: [  133.624291] [drm:i915_do_wait_request] 
> *ERROR* i915_do_wait_request returns -5 ( awaiting 691 at 682)
> Mar 25 19:58:11 gumis kdm[2592]: X server for display :0 terminated 
> unexpectedly
> 
> after this only SysRq keys work.
> 
> Similar problem (older kernels):
> https://bugzilla.kernel.org/show_bug.cgi?id=15004
> 
> Workaround: setting i915.modeset=1 pci=nocrs OR i915.modeset=0
> 
> Dmesg with i915.modeset=1 pci=nocrs:
> http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/dmesg2.6.34-rc2.txt
> 
> Config:
> http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/config-2.6.34-rc2
> 
> Syslog (i915.modeset=1 -- when hangs)):
> http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/syslog-2.6.34-rc2
> 
> lspci:
> http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/lspci.txt
> 
> Regards
> 

