Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0GaVcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:32:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64762 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab0GaVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wjbahvVzVUpe39L7metxaud5E4nh/iJcDy/32qy5BPixvg016f/jWqLcUYDFeR/b+b
         VNNYsNTm2Y87raFedHCMFFpN5omUwh0Uo9cHl0C6vSBdJuTBtJp2axn71A8LtT5+pHfN
         O5QNEY+cv0n1etI/J24Q2owCZGFboqYKhrJV8=
Date: Sun, 1 Aug 2010 01:31:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
Message-ID: <20100731213138.GC29357@lenovo>
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo> <4C5469AF.2010608@zytor.com> <20100731183211.GB29357@lenovo> <4C548F7D.6000509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C548F7D.6000509@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 02:02:53PM -0700, H. Peter Anvin wrote:
> On 07/31/2010 11:32 AM, Cyrill Gorcunov wrote:
> >>
> >> No, this is the internal part of the boot protocol, so it's not an issue.
> >>
> > 
> > Peter, I didn't mean any issue here, I meant that bootloaders don't know about
> > this field yet and they will have to update own sources to pass port value
> > at proper place of boot params. Or I miss something?
> > 
> 
> Boot loaders that use the 16-bit entry point are unaffected.
> 
> Boot loaders which use the 32-bit entry point but properly clears the
> zero page simply will not have the feature.
> 
> Boot loaders which use the 32-bit entry point but doesn't clear the zero
> page are broken.
> 
> 	-hpa
>

Well, Peter, seems I messed boot params with setup header. So I don't see
any user of this field then, hmm...

	-- Cyrill
