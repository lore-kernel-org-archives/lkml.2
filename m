Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2DWQ47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:56:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44991 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2DWQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:56:58 -0400
Date: Mon, 23 Apr 2012 12:51:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423165128.GA22364@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
 <20120423153222.GE24481@phenom.dumpdata.com>
 <3908561D78D1C84285E8C5FCA982C28F170EF914@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F170EF914@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 04:17:14PM +0000, Luck, Tony wrote:
> > This driver is _not_ doing a strict bit-by-bit copy of 'struct mcinfo'
> > to 'struct mce'. It is plucking the right bits and setting them in
> > 'struct mce'.
> 
> That isn't any worse that what we currently have ... but what we currently
> have is ugly, and doing more ugly things just because we did them before
> generally isn't a winning argument on the mailing lists.

Heh.

Until about an hour ago I did not know that what is there is considered
'ugly' and you guys had thoughts of how to make it nicer. That is good.
And the driver isn't set in stone by only using those function - it can
change.

I am not sure if I have stated, but providing this driver in my mind
is an implicit contract that I, as the sub-maintainer, will keep it
in lock-step with mce.h cleanups. That is after all, the job of a
(sub)-maintainer.
