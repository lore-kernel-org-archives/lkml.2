Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1CPNsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:48:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48269 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1CPNsL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Mar 2011 09:48:11 -0400
Date: Wed, 16 Mar 2011 09:47:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, dgdegra@tycho.nsa.gov,
        xen-devel@lists.xensource.com, Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 1/4] xen-fbfront: Read width/height from
 backend
Message-ID: <20110316134754.GC4959@dumpdata.com>
References: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
 <1300198274-1325-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300198274-1325-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D80BF8D.013D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:11:12AM -0400, Konrad Rzeszutek Wilk wrote:
> From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> 
> This allows the backend driver to specify the size of the framebuffer
> instead of requiring it to be on the kernel command line.
> 
> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Replace Acked-by by Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
please.
