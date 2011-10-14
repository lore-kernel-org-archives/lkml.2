Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab1JNOmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:42:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20735 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab1JNOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:42:19 -0400
Date: Fri, 14 Oct 2011 10:42:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
Message-ID: <20111014144208.GB12349@phenom.oracle.com>
References: <1318595439.6132.77.camel@x61.thuisdomein>
 <20111014135743.GD4577@phenom.oracle.com>
 <1318601485.6132.91.camel@x61.thuisdomein>
 <20111014142254.GA8887@phenom.oracle.com>
 <1318602649.6132.102.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318602649.6132.102.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E984A49.0053:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:30:49PM +0200, Paul Bolle wrote:
> On Fri, 2011-10-14 at 10:22 -0400, Konrad Rzeszutek Wilk wrote:
> > Why? Is it b/c PCI_DEBUG does not exist? How did you determine it is
> > unused?
> 
> $ git grep -n XEN_PCIDEV_FE_DEBUG
> $
> 
> So there's no other Kconfig symbol that depends in this symbol. Neitehr
> is there anything that uses CONFIG_XEN_PCIDEV_FE_DEBUG.

Excellent. Can you include that in the description please then.

And you can also include 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
on that patch.
