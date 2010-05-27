Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0E0Nvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:51:40 -0400
Received: from dspnet.fr ([188.165.44.67]:53156 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0E0Nvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:51:39 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 09:51:39 EDT
Date: Thu, 27 May 2010 15:41:20 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Frank Pan <frankpzh@gmail.com>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
Message-ID: <20100527134120.GA44150@dspnet.fr>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com>
 <20100526151152.28deaa6c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526151152.28deaa6c@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:11:52PM +0100, Alan Cox wrote:
> On Wed, 26 May 2010 14:55:04 +0800
> Frank Pan <frankpzh@gmail.com> wrote:
> 
> > Greetings
> > 
> > The motivation is display much more characters on the
> > framebuffer console than 512. If this is done, foreign
> > languages can be easily rendered with currently supported
> > utf-8 encoding.
> 
> This has been suggested a couple of times but unfortunately it's not
> enough to use bigger fonts. Rendering many non western languages is far
> far more complex. In addition the text mode vt driver is limited to 512
> symbols by the hardware.

The Unicode book should be required reading for anyone who starts
talking about displaying utf-8/unicode text.  It's a *very*
interesting book with way more than code charts in it[1].

  OG.
