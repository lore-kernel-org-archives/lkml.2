Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1CPNru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:47:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47544 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1CPNro (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Mar 2011 09:47:44 -0400
Date: Wed, 16 Mar 2011 09:47:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, dgdegra@tycho.nsa.gov,
        xen-devel@lists.xensource.com, Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 3/4] xen-fbfront: Use grant references when
 requested
Message-ID: <20110316134732.GB4959@dumpdata.com>
References: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
 <1300198274-1325-4-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300198274-1325-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D80BF76.0249,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:11:14AM -0400, Konrad Rzeszutek Wilk wrote:
> From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> 
> The current version of the Xen framebuffer API passes MFNs directly
> to the backend driver, which requires the backend to have full access
> to this domain's memory. Add a parameter in xenbus to request the use of
> grant entries instead, which are slightly slower to map but provide
> inter-domain isolation.
> 
> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Replace Acked-by by Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
please.
