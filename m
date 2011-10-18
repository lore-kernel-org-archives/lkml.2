Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab1JRP4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:56:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:59254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab1JRP4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:56:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,366,1315206000"; 
   d="scan'208";a="79290650"
From: Andi Kleen <andi@firstfloor.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: IOMMU keeping mapping over long period of time
References: <20111018154828.GA4201@homer.localdomain>
Date: Tue, 18 Oct 2011 08:56:14 -0700
In-Reply-To: <20111018154828.GA4201@homer.localdomain> (Jerome Glisse's
	message of "Tue, 18 Oct 2011 11:48:28 -0400")
Message-ID: <m2ehyaz42p.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse <j.glisse@gmail.com> writes:
>
> GPU for which we are interested have dma mask of 40bits at least, thus
> they can work with high mem page. My main concern is when an iommu is
> active, such amount of continuously mapped page might exhaust the iommu
> address space. My understanding is that Intel & AMD iommu are capable of
> growing their address space but is it somethings we can rely on ?

I don't think relying on this is very wise. Better add some way to unmap
when space is running short.

-Andi
