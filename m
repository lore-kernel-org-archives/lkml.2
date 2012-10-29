Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2J2Oc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:32:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41097 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2J2Ocz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:32:55 -0400
Date: Mon, 29 Oct 2012 10:20:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
Subject: Re: [PATCH+GIT V3 0/5] arm: implement ballooning and privcmd foreign
 mappings based on x86 PVH
Message-ID: <20121029142023.GB2708@phenom.dumpdata.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 02:19:16PM +0100, Ian Campbell wrote:
> This is rebased onto 0e9e3e306c7e (AKA current Linus, which now includes
> the previously prerequisite series "xen: build fixes and interface
> tweaks") and Konrad's stable/pvh.v5 branch.
> 
> For convenience I've also pushed to 
>         git://xenbits.xen.org/people/ianc/linux.git
>         arm-privcmd-on-x86-pvh5
> Note that this contains my merge of Konrad's branch into Linus' tree at
> the base. You might want to cherry pick it rather than merge it.

Applied them and stuck them in 'devel/pvh.v6' - which is based on v3.7-rc3.

Will test them overnight.
> 
> Ian.
