Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1CPNqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:46:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44321 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1CPNqH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Mar 2011 09:46:07 -0400
Date: Wed, 16 Mar 2011 09:45:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, dgdegra@tycho.nsa.gov
Subject: Re: [PATCH 2/4] xen-kbdfront: Add grant reference for shared page
Message-ID: <20110316134551.GB4881@dumpdata.com>
References: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
 <1300198274-1325-3-git-send-email-konrad.wilk@oracle.com>
 <20110316053426.GB14604@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316053426.GB14604@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D80BF14.0165,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:34:26PM -0700, Dmitry Torokhov wrote:
> On Tue, Mar 15, 2011 at 10:11:13AM -0400, Konrad Rzeszutek Wilk wrote:
> > From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> > 
> > Without a grant reference, full access to the domain's memory is
> > required to use the shared page. Add an additional parameter in
> > xenstore to allow grant mapping to be used.
> > 
> > Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> > Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> You are passing the patch on so it should be Signed-off-by...

Oh, somehow I thought that I was suppose to change my SOB to ACK
since it would now go through your tree.

> 
> It is independent of the other 2 so I can pick it up and merge (so that
> we do not have conflicts with move), right?

Yes.

> 
> -- 
> Dmitry
