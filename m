Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2GZPrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:47:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51769 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2GZPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:47:06 -0400
Date: Thu, 26 Jul 2012 17:47:09 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Subject: Re: drm/nouveau: crash regression in 3.5
Message-ID: <20120726154709.GA3220@joi.lan>
References: <500D916A.60703@odi.ch>
 <20120724170002.GA3129@joi.lan>
 <500ED9EC.5040309@odi.ch>
 <20120724205746.GA8707@joi.lan>
 <500FB279.1020904@odi.ch>
 <20120725184205.GA3119@joi.lan>
 <50113E76.9090706@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50113E76.9090706@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 02:56:22PM +0200, Ortwin Glück wrote:
> On 25.07.2012 20:42, Marcin Slusarz wrote:
> > Good, below patch should fix this panic.
> >
> > Note that you can hit an oops in drm_handle_vblank because patch from
> > http://lists.freedesktop.org/archives/dri-devel/2012-May/023498.html
> > has not been applied (yet?).
> 
> After applying your patch, it still crashes, although with a slightly 
> different stack trace. I then also applied the second patch, but that 
> doesn't make any difference. New log attached.
> 
> Looks like interrupt occurs before nouveau_software_context_new() is 
> called? Shouldn't the initialization be done from 
> nouveau_irq_preinstall() so it is available when the irq occurs? Again, 
> I am not an expert here. Just guessing...

I didn't look at it yet, but can you catch panic with maxcpus=1?

Marcin
