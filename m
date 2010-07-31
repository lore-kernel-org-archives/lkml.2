Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0GaScS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 14:32:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52938 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0GaScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 14:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kLwbFmWovCCAiOYqizFw8y7EHD2W04cldq0XieQiXQk0tX4yUYHwJNRzo1Jd4//MPO
         CJPPbHk4l8g6RNdRgH/2+F/EP8PLhvb8fDrfRkkHSUNKUSkh1zyCS2QBBmGEdJrtAaBj
         FnoIKl+gG2a2ztg1kiQsbK8N19MR35deiXVQA=
Date: Sat, 31 Jul 2010 22:32:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
Message-ID: <20100731183211.GB29357@lenovo>
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo> <4C5469AF.2010608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5469AF.2010608@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 11:21:35AM -0700, H. Peter Anvin wrote:
> On 07/31/2010 01:34 AM, Cyrill Gorcunov wrote:
> > On Thu, Jul 15, 2010 at 03:27:18PM -0700, Yinghai Lu wrote:
> >>
> >> to save the early_serial_base.
> >>
> >> Also bootloader could fill that field, so setup code could reuse it.
> >>
> >> decompress code could reuse early serial console from setup code.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> > 
> > Hi Yinghai, sorry for delayed response. I like the idea much since it'll allow
> > to log decompressor messages in case if someone would be changing exitsting code
> > or developing new one, though this touches boot protocol so that grub/syslinux
> > and friends will have to update their code as well which of course need some
> > time.
> > 
> 
> No, this is the internal part of the boot protocol, so it's not an issue.
> 

Peter, I didn't mean any issue here, I meant that bootloaders don't know about
this field yet and they will have to update own sources to pass port value
at proper place of boot params. Or I miss something?

> 	-hpa
> 
	-- Cyrill
