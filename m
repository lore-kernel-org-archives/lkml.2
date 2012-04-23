Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2DWQR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:17:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54430 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab2DWQRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:17:55 -0400
Message-ID: <4F958098.1050402@zytor.com>
Date: Mon, 23 Apr 2012 09:17:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com> <20120421041454.GA29704@phenom.dumpdata.com> <20120421104502.GB17005@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 08:27 AM, Luck, Tony wrote:
>> Because, if you'd hooked into it, just imagine one fine day, when we
>> remove mcelog support, what screaming the xen people will be doing when
>> mcelog doesn't work anymore.
> 
> Agreed. Even before we get to deleting mcelog, "struct mce" can change (new
> fields could be added) ... and you don't want to have your hypervisor to
> have to know which version of Linux it is talking to.

This is a great example on the fundamental problem with Xen, or rather
the approach that Xen has taken of grabbing random kernel internals and
claiming them as APIs (or, in some cases even as ABIs.)  A lot of these
have had problems that are now very nearly unfixable, and that has
seriously stalled out the ability of evolve the Linux kernel in some
areas.  Note that the cost of this is borne by the development
community, not by the Xen maintainers.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

