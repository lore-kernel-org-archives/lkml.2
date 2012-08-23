Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab2HWM3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:29:35 -0400
Received: from mail.x86-64.org ([217.9.48.20]:44582 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab2HWM3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:29:31 -0400
Date: Thu, 23 Aug 2012 14:29:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, tony.luck@intel.com, andi@firstfloor.org,
        gong.chen@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        linux-edac@vger.kernel.org, ananth@in.ibm.com,
        Chris McDermott <lcm@us.ibm.com>, masbock@linux.vnet.ibm.com
Subject: Re: [PATCH] x86: mce: Honour bios-set CMCI threshold
Message-ID: <20120823122919.GB18279@aftab.osrc.amd.com>
References: <20120822123054.29238.3864.stgit@localhost.localdomain>
 <20120822124649.GD5817@aftab.osrc.amd.com>
 <50361D25.5020704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50361D25.5020704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:38:05PM +0530, Naveen N. Rao wrote:
> Sure - that sounds like a good idea. Further, a #define can be used to
> avoid the need to change other references, though I'm not sure it's
> considered good practice:
>
> #define mce_bios_cmci_threshold boot_flags.mce_bios_cmci_threshold

That would hide the fact that this flag is part of the boot_flags struct
and would obfuscate the code. We can always add it later though, if it
makes sense.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
