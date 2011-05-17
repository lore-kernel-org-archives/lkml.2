Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1EQSHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:07:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35467 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab1EQSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:07:34 -0400
Date: Tue, 17 May 2011 14:07:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, Keir Fraser <keir@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and initial_memory_mapping.
Message-ID: <20110517180715.GD13706@dumpdata.com>
References: <20110513153010.GB16519@dumpdata.com>
 <alpine.DEB.2.00.1105131650550.8972@kaball-desktop>
 <20110516154132.GA12486@dumpdata.com>
 <4DD19D1F.3070506@linux.intel.com>
 <alpine.DEB.2.00.1105171744230.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105171744230.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DD2B960.00DE:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Doesn't Xen have some kind of compatibility mode which could be used
> > during setup?
>  
> Unfortunately not that I am aware.

Peter, were you thinking of XENFEAT_auto_translated_physmap? Which is that
the hypervisor does all of the MMU translations?
