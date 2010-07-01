Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0GALiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:38:24 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:49498 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0GALiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:38:23 -0400
X-IronPort-AV: E=Sophos;i="4.53,519,1272844800"; 
   d="scan'208";a="690127"
Date: Thu, 1 Jul 2010 12:38:37 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 0/12] PV on HVM Xen
In-Reply-To: <20100630175637.GC16488@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1007011111510.30135@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <20100630175637.GC16488@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 21, 2010 at 05:12:20PM +0100, Stefano Stabellini wrote:
> > Hi all,
> > this is another update on the PV on HVM Xen series; a list of changes
> > compared to the previous version follows:
> 
> Can you use the [v4] in the main patch (this is the fourth version of
> these patches, right?)? I am getting confused as to which version I am
> reviewing and if I've missed one or what not.
> 
> And in this first intro email state:
> 
> Since v7 the following things have changed:
>  - Konrad made some comments.
>  - etc.
> 

Good point, I'll do that from now on.
I am pretty sure that you are reviewing the latest version I sent.
