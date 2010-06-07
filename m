Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0FGTbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:31:49 -0400
Received: from coloquinte.cristau.org ([91.121.16.100]:60778 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab0FGTbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:31:48 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jun 2010 15:31:48 EDT
Date: Mon, 7 Jun 2010 21:24:11 +0200
From: Julien Cristau <jcristau@debian.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
       Dave Airlie <airlied@redhat.com>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
Message-ID: <20100607192411.GV3043@radis.liafa.jussieu.fr>
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr>
 <s5hmxvmzwwd.wl%tiwai@suse.de>
 <alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr>
 <4BFD2901.20800@ladisch.de>
 <alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr>
 <4BFE5AA1.7070103@ladisch.de>
 <4BFE66CA.5070400@ladisch.de>
 <alpine.LSU.2.01.1006071404210.11780@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1006071404210.11780@obet.zrqbmnf.qr>
X-Operating-System: Linux 2.6.32-5-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun  7, 2010 at 14:49:16 +0200, Jan Engelhardt wrote:

> * The radeon.ko module does not have any PCI IDs defined, thus does not 
> get autoloaded like i915.ko. Is this intentional? It also seems
> to default to modeset=0.

It only defines PCI IDs (and gets autoloaded) if CONFIG_DRM_RADEON_KMS=y.

Cheers,
Julien
