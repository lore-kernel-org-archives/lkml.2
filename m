Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0CQWDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:03:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:32771 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab0CQWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:03:05 -0400
In-Reply-To: <20100317213504.GA7433@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org,
       Paul Moore <paul.moore@hp.com>, sri@linux.vnet.ibm.com
MIME-Version: 1.0
Subject: Re: [PATCH RFC] tun: add ioctl to modify vnet header size
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFB24B6EEE.B788B01F-ON882576E9.00789167-882576E9.0079198A@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Wed, 17 Mar 2010 15:02:44 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 8.5.1HF41 | October 22, 2009) at
 03/17/2010 16:02:45,
	Serialize complete at 03/17/2010 16:02:45
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netdev-owner@vger.kernel.org wrote on 03/17/2010 02:35:04 PM:

> On Wed, Mar 17, 2010 at 02:10:11PM -0700, David Stevens wrote:
> > Shouldn't we enforce a maximum too? Esp. if overflow/underflow
> > will break any of the checks when it's used.
> > 
> >                                 +-DLS
> 
> So the maximum is MAX_INT :)
> I don't think it can break any checks that aren't
> already broken - what do you have in mind?

        I was thinking more like a page. At least, it'd be better
to fail when trying to set it large than failing allocations
later. As a header, it really ought to be small.
        But if it works, or fails gracefully, at 2^31-1 on 32-bit
machines, negative values, etc, then it's ok. Just a suggestion.

                                                        +-DLS

