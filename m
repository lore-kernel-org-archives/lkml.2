Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2CELtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 06:49:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:24488 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab2CELtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 06:49:13 -0500
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Matt Fleming <matt.fleming@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <86wr71up4j.fsf@sumi.keithp.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	 <86zkbxusu2.fsf@sumi.keithp.com> <4F52B6F0.6060902@zytor.com>
	 <86wr71up4j.fsf@sumi.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Mon, 05 Mar 2012 11:48:40 +0000
Message-ID: <1330948120.3539.16.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-03 at 17:33 -0800, Keith Packard wrote:
> <#part sign=pgpmime>
> On Sat, 03 Mar 2012 16:27:28 -0800, "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Do you have the dmesg from your MBA?  I'm wondering what the memory map
> > looks like...
> 
> Here's the first part of dmesg from a running kernel (3.3-rc1 plus some
> DRM patches). Let me know if I cut this off too soon...

Have you tried adding 'add_efi_memmap' to your kernel command line?


