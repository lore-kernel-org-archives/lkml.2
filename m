Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2DXI1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:27:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:56666 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab2DXI1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:27:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145181392"
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Liu\, Jinsong" <jinsong.liu@intel.com>, tony.luck@intel.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
	<20120421041454.GA29704@phenom.dumpdata.com>
	<20120421104502.GB17005@aftab.osrc.amd.com>
Date: Tue, 24 Apr 2012 01:27:35 -0700
In-Reply-To: <20120421104502.GB17005@aftab.osrc.amd.com> (Borislav Petkov's
	message of "Sat, 21 Apr 2012 12:45:02 +0200")
Message-ID: <m2aa21o7pk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@amd64.org> writes:

> Because, if you'd hooked into it, just imagine one fine day, when we
> remove mcelog support, what screaming the xen people will be doing when
> mcelog doesn't work anymore.

That's simple. /dev/mcelog is a widely used user space ABI and Linux
does never remove widely used user space ABIs, so this can never happen.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
