Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2ILDTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:19:14 -0400
Received: from tundra.namei.org ([65.99.196.166]:57802 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627Ab2ILDTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:19:13 -0400
Date: Wed, 12 Sep 2012 13:12:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] tpm: fix tpm_acpi sparse warning on different address
 spaces
In-Reply-To: <20120904161819.GB20588@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.02.1209121312300.4482@tundra.namei.org>
References: <20120830143839.GA9589@linux.vnet.ibm.com> <20120830174556.GD20741@mwanda> <20120830192155.GA25524@linux.vnet.ibm.com> <20120902163030.GB1840@mwanda> <20120904161819.GB20588@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012, Kent Yoder wrote:

> acpi_os_map_memory expects its return value to be in the __iomem address
> space. Tag the variable we're using as such and use memcpy_fromio to
> avoid further sparse warnings.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
