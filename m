Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1FPQTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:19:00 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:40059 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab1FPQSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:18:55 -0400
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 12:18:55 EDT
Date: Thu, 16 Jun 2011 13:18:03 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org
Subject: Re: Graphic corruption with i915 (2.6.39.1)
Message-ID: <20110616161803.GQ20487@llucax.com.ar>
References: <20110616145842.GM20487@llucax.com.ar>
 <013811$g9fu7@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <013811$g9fu7@fmsmga002.fm.intel.com>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson, el 16 de junio a las 17:01 me escribiste:
> On Thu, 16 Jun 2011 11:58:42 -0300, Leandro Lucarella <luca@llucax.com.ar> wrote:
> > Hi, I've been experiencing sporadic graphic corruption since a few
> > stable kernel versions and I always thought "maybe is fixed in the next
> > release", so I upgrade, but I usually experience a different problem
> > then. This problems are exposed very rarely, maybe I have no problems
> > like for a month or so.
> > 
> > Now I'm using kernel 2.6.39.1 and I experience one of this problem so
> > I though it was time to report it. This is what I got in dmesg:
> > 
> > [368693.756008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> > [368693.756014] render error detected, EIR: 0x00000010
> > [368693.756017]   IPEIR: 0x00000000
> > [368693.756019]   IPEHR: 0x02000004
> > [368693.756020]   INSTDONE: 0xcc8fffff
> > [368693.756022]   INSTPS: 0x8001e025
> > [368693.756024]   INSTDONE1: 0xbfffffbf
> > [368693.756026]   ACTHD: 0x00715128
> > [368693.756027] page table error
> > [368693.756029]   PGTBL_ER: 0x00000002
> > [368693.756038] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 17700193 at 17700192, next 17700196)
> > [368694.258010] [drm:i915_reset] *ERROR* Failed to reset chip.
> 
> If you look in /sys/kernel/debug/dri/0/i915_error_state we can see what
> garbage the DDX [xf86-video-intel] fed the gpu.

cannot access /sys/kernel/debug/dri/0/i915_error_state: No such file or directory

The debug directory is not present, should I boot or compile with some
particular option to enable it?

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
Refalar: acto de mover el peso de la masa hacia un lugar equivocado pero
concreto. Todo refalo es, por cierto, una sucesión de pequeñísimos
movimientos a los que un centímetro es la proporción aumentada de miles
de porciones de espacio, que, al estar el piso mojado, refala.
	-- Ricardo Vaporeso
