Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab2CGSSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:18:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56023 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab2CGSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:18:11 -0500
Date: Wed, 7 Mar 2012 18:18:00 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@kernel.org>,
        mingo@redhat.com, linux-kernel@vger.kernel.org, keithp@keithp.com,
        rui.zhang@intel.com, huang.ying.caritas@gmail.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
Message-ID: <20120307181800.GA15211@srcf.ucam.org>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
 <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
 <4F45B35D.1010702@zytor.com>
 <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
 <4F471651.3080609@zytor.com>
 <4F4C3BA2.1070708@kernel.org>
 <1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAE9FiQWrh5fOzAj_f03iqF+pQjGExvzppVoeJjwnp0p030jDPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWrh5fOzAj_f03iqF+pQjGExvzppVoeJjwnp0p030jDPA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:14:15AM -0800, Yinghai Lu wrote:

> but my question is:
> is there any system that will put EFI runtime, or ACPI or NVS above
> 4G? is that legal?

You can't run a 32-bit EFI OS on a 64-bit EFI system, so there's no 
obvious reason why there couldn't be runtime regions above 4GB.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
