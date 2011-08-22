Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1HVRXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 13:23:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40152 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1HVRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 13:23:36 -0400
Date: Mon, 22 Aug 2011 13:23:28 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry (v2)
Message-ID: <20110822172328.GC12337@hmsreliant.think-freely.org>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110808191354.GA22117@hmsreliant.think-freely.org>
 <20110822164626.GI2079@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822164626.GI2079@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.7 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 06:46:26PM +0200, Roedel, Joerg wrote:
> Hi Neil,
> 
> I applied your patch and did some minor changes and fixed one problem I
> have seen. Find the edited version appended, when this is fine for you I
> push it.
> 
> Thanks,
> 	Joerg
> 
> On Mon, Aug 08, 2011 at 03:13:54PM -0400, Neil Horman wrote:
> > +		range += (1 << HASH_FN_SHIFT);
> > +		put_hash_bucket(*bucket, flags);
> > +		index.dev_addr -= HASH_FN_SHIFT;
> 
> This should be index.dev_addr -= (1 << HASH_FN_SHIFT), right?
> 
Yup, thats right, good catch, thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

