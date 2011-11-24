Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1KXVbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:31:25 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:51457 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab1KXVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:31:24 -0500
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Mike Waychison <mikew@google.com>,
        Andi Kleen <andi@firstfloor.org>, Peter Jones <pjones@redhat.com>
In-Reply-To: <20111124210749.GA14428@srcf.ucam.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
	 <1318848017-12301-11-git-send-email-matt@console-pimps.org>
	 <4E9C8AAC.7080803@gmail.com>
	 <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECC4207.3010607@gmail.com>
	 <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECE5803.3060203@gmail.com>
	 <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20111124210749.GA14428@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 21:31:13 +0000
Message-ID: <1322170273.24448.62.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 21:07 +0000, Matthew Garrett wrote:
> grub needs to be able to read files off filesystems that may not be 
> supported by the UEFI implementation, so has its own filesystem drivers 
> that use disk_io.

Ah, of course. Thanks Matthew.

-- 
Matt Fleming, Intel Open Source Technology Center

