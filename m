Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1KAOdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:33:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42823 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1KAOdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:33:12 -0400
Date: Tue, 1 Nov 2011 10:37:15 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, thellstrom@vmware.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, j.glisse@redhat.com,
        airlied@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH 06/11] ttm/driver: Expand ttm_backend_func to include two
 overrides for TTM page pool.
Message-ID: <20111101143715.GA8631@homer.localdomain>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
 <1319062772-2793-7-git-send-email-konrad.wilk@oracle.com>
 <4EA28FA6.7000006@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA28FA6.7000006@shipmail.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 11:40:54AM +0200, Thomas Hellstrom wrote:
> Konrad,
> 
> I was hoping that we could get rid of the dma_address shuffling into
> core TTM,
> like I mentioned in the review. From what I can tell it's now only
> used in the backend and
> core ttm doesn't care about it.
> 
> Is there a particular reason we're still passing it around?
> 
> Thanks,
> /Thomas
> 

I am working on patchset on top of this that will move dma handling
back to driver and mostly out of ttm (the page alloc helper will
still do dma stuff on behalf of driver) So if my patchset is acceptable
the dma situation is transionary.

Cheers,
Jerome
