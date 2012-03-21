Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab2CUEhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:37:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48560 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2CUEhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:37:36 -0400
Date: Wed, 21 Mar 2012 12:37:21 +0800
From: Wang YanQing <udknight@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2] x86: export 'pcibios_enabled' as GPL
Message-ID: <20120321043721.GA927@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Michal Januszewski <spock@gentoo.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-fbdev@vger.kernel.org, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
 <4F5FAE63.3090908@xenotime.net>
 <20120319003044.GA3744@udknight>
 <4F6685ED.7040000@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6685ED.7040000@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 06:03:41PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Export 'pcibios_enabled' so that when uvesafb is built as a
> loadable module (on X86_32), the build will succeed.
> 
> ERROR: "pcibios_enabled" [drivers/video/uvesafb.ko] undefined!
> 
> Patch v2 uses EXPORT_SYMBOL_GPL() as requested.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	Michal Januszewski <spock@gentoo.org>
> Cc:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc:	linux-fbdev@vger.kernel.org
> Cc:	x86@kernel.org
> ---
>  arch/x86/pci/pcbios.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20120313.orig/arch/x86/pci/pcbios.c
> +++ linux-next-20120313/arch/x86/pci/pcbios.c
> @@ -27,6 +27,7 @@
>  #define PCIBIOS_HW_TYPE2_SPEC		0x20
>  
>  int pcibios_enabled;
> +EXPORT_SYMBOL_GPL(pcibios_enabled);
>  
>  /* According to the BIOS specification at:
>   * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could
Acked-by: Wang YanQing <udknight@gmail.com>
