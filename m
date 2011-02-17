Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1BQOx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:53:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:49190 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1BQOx4 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 17 Feb 2011 09:53:56 -0500
Date: Thu, 17 Feb 2011 09:52:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 1/3] pci/xen: Use xen_allocate_pirq_msi
Message-ID: <20110217145255.GA32341@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
 <1297894638-28007-2-git-send-email-konrad.wilk@oracle.com>
 <1297932091.16356.1292.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297932091.16356.1292.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D5D3677.0156:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All callers have this (type == MSIX) ? "msi-x" : "msi" construct,
> differing only in their use of a "pcifront-" prefix. Something which
> could be hoisted into the function perhaps?

I was thinking to defer this for a cleanup patch.
> 
> Another aside: I think there are other cleanups which could be made to
> the various pirq allocation/mapping interfaces (of which there seem to
> be too many, or at least their individual unique qualities are
> indistinguishable by their names), I made a start on this at one point
> since I wanted to get rid of the pirq_to_irq[nr_irqs] array, for obvious
> reasons, but didn't finish it off. I'll hopefully revisit this soon.

Excellent. Looking forward to it.
