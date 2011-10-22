Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1JVBI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 21:08:26 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38262 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1JVBIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 21:08:25 -0400
Date: Sat, 22 Oct 2011 10:08:21 +0900
From: Simon Horman <horms@verge.net.au>
To: Dave Young <dyoung@redhat.com>
Cc: kexec@lists.infradead.org, iommu@lists.linux-foundation.org,
        vgoyal@redhat.com, linux-kernel@vger.kernel.org, luyu@redhat.com
Subject: Re: [PATCH] intel-iommu:make identity_map default for crash dump
Message-ID: <20111022010821.GF21850@verge.net.au>
References: <20111021123154.GA5821@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021123154.GA5821@darkstar.nay.redhat.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 08:31:54PM +0800, Dave Young wrote:
> kdump kernel sometimes will get DMAR faults which
> is caused by random in-flight dma from 1st kernel
> 
> Here make the identity_mapping as default for this case

This seems reasonable to me. Although I am curious to know
what the side effects of using IDENTMAP_ALL might be.
