Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0HCPH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:07:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54954 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0HCPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mCO7BkcYJrzE7Otdpl/ItoMuzuBPD5EZM0/51O0cKKpmMn0xDG9I0UlSoWR8IqhgsJ
         Y/XLfnTXXYE5OrnCSgXyujGYFHVkY7bJTB4iFZNKFc6C68lYfCC17g7XL+P0w3f3cS1A
         O2bS50gYXUtJ25o1pCGO/QLDQQndGyg/Ct8qk=
Date: Tue, 3 Aug 2010 19:07:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3] x86: Setup early console as early as possible
Message-ID: <20100803150747.GB6928@lenovo>
References: <4C56701B.1030000@kernel.org> <20100802150958.GA5544@lenovo> <4C571B25.3080806@kernel.org> <20100802201750.GG5544@lenovo> <4C57C1DE.9050400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C57C1DE.9050400@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 12:14:38AM -0700, Yinghai Lu wrote:
> 
> Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
> and call setup_early_serial8250_console() to init early serial console.
> 
> only can handle io port kind of 8250. because mmio need ioremap.
> 
> -v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
>      update after using x86 memblock patchset
> -v3: x86 memblock can not make into with 2.6.36 now
>      so update this patch to be applied before x86 memblock patchset again.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---

Looks good to me, thanks Yinghai!
 
	-- Cyrill
