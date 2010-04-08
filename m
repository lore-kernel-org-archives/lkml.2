Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0DHATj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 20:19:39 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:50600 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab0DHATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 20:19:36 -0400
Date: Wed, 7 Apr 2010 17:19:35 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai <yinghai.lu@oracle.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
Message-ID: <20100408001935.GM29192@hexapodia.org>
References: <20100407210628.28364.96982.stgit@bob.kio> <4BBD0B0A.3090702@oracle.com> <4BBD18B0.6010302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBD18B0.6010302@zytor.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 04:43:44PM -0700, H. Peter Anvin wrote:
> > or you can add
> > boot_params.screen_info.orig_video_isVGA == 1
> > or double check scan pci tree to see if video is there or not
> 
> Perhaps boot_params.screen_info.orig_video_isVGA != 1 because he's not
> booting in a text mode?

It's a pretty standard grub2 install (Debian unstable,
1.98~20100128-1.2) with something approaching the default config.  Grub
does seem to put the console in some annoying framebuffer format to draw
the boot menu, but IIRC it switches back to VGA textmode before booting
the kernel.

-andy
