Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0GaIeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 04:34:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45047 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0GaIeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 04:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P6enr8YwT7IZK/anWU54CE1zcgwj0wBD0A17ZREYtdmMcq+WnATiCoyllTSJDrxSaC
         Ci1MKy63DZj2UaWRAymp9livk0h7cOjYsyIA7fQDg5RxbhikpCwY5lBmJTP8PmijunaG
         207DRYh+Uc0gDgVDW5aq3TAKao+HXzmbQUchc=
Date: Sat, 31 Jul 2010 12:34:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
Message-ID: <20100731083409.GC5859@lenovo>
References: <4C3F8B46.7080809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3F8B46.7080809@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 03:27:18PM -0700, Yinghai Lu wrote:
> 
> to save the early_serial_base.
> 
> Also bootloader could fill that field, so setup code could reuse it.
> 
> decompress code could reuse early serial console from setup code.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

Hi Yinghai, sorry for delayed response. I like the idea much since it'll allow
to log decompressor messages in case if someone would be changing exitsting code
or developing new one, though this touches boot protocol so that grub/syslinux
and friends will have to update their code as well which of course need some
time.

	-- Cyrill
