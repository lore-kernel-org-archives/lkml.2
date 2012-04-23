Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2DWQ1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:27:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54514 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab2DWQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:27:03 -0400
Message-ID: <4F9582C2.6020009@zytor.com>
Date: Mon, 23 Apr 2012 09:26:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com> <20120421041454.GA29704@phenom.dumpdata.com> <20120421104502.GB17005@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com> <DE8DF0795D48FD4CA783C40EC8292335168D26@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335168D26@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 08:43 AM, Liu, Jinsong wrote:
> 
> and, hypervisor only record error into its mc_info cookie (in its
> own format), it doesn't care what's dom0's version and how dom0 translate it
> -- that's dom0's business. The role of hypervisor is virtual 'platform',
> just like h/w platform don't care what linux version runs over it.
> 

And this is the *OTHER* problem with Xen.  A platform is only a platform
if it is documented.  There are a number of PV hypervisors which *are*
documented in detail, but Xen is not one of them.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

