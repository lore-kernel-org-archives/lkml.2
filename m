Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2BTADb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:03:31 -0500
Received: from ozlabs.org ([203.10.76.45]:51333 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2BTAD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:03:29 -0500
Date: Mon, 20 Feb 2012 10:47:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Amerigo Wang <amwang@redhat.com>, Kexec-ml <kexec@lists.infradead.org>,
        Milton Miller <miltonm@bga.com>, Haren Myneni <hbabu@us.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ananth Narayan <ananth@in.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [RFC PATCH v7 00/10] fadump: Firmware-assisted dump support for
 Powerpc.
Message-ID: <20120219234751.GA10186@bloggs.ozlabs.ibm.com>
References: <20120216111050.4733.38034.stgit@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216111050.4733.38034.stgit@mars>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 04:44:06PM +0530, Mahesh J Salgaonkar wrote:

> Please find the version 7 of the patchset that implements firmware-assisted
> dump mechanism to capture kernel crash dump for Powerpc architecture.
> Firmware-assisted dump is a robust mechanism to get reliable kernel crash
> dump with the assistance of firmware. This approach does not use kexec,
> instead firmware assists in booting the kdump kernel while preserving memory
> contents.

For the series:

Reviewed-by: Paul Mackerras <paulus@samba.org>

I think it's pretty much good enough to go in now.  I have one relatively
minor comment about a printk which could be addressed if you decide to
do another version of the series.

Paul.
