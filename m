Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0CQVjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:39:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0CQVjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:39:43 -0400
Date: Wed, 17 Mar 2010 23:35:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Stevens <dlstevens@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Paul Moore <paul.moore@hp.com>,
       sri@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] tun: add ioctl to modify vnet header size
Message-ID: <20100317213504.GA7433@redhat.com>
References: <20100317154501.GA5244@redhat.com> <OF526018DA.E6922CE9-ON882576E9.0073CB01-882576E9.007449E0@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF526018DA.E6922CE9-ON882576E9.0073CB01-882576E9.007449E0@us.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 02:10:11PM -0700, David Stevens wrote:
> Shouldn't we enforce a maximum too? Esp. if overflow/underflow
> will break any of the checks when it's used.
> 
>                                 +-DLS

So the maximum is MAX_INT :)
I don't think it can break any checks that aren't
already broken - what do you have in mind?


-- 
MST
