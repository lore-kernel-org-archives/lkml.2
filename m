Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0JLCLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 22:11:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31050 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab0JLCLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 22:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=QBMwZbjgDxIYuNAaAFoViexn6bfBShYG55mzddpfmTgKF9pX3f00H9EIYgY2gdILoF
         NlJM2MpplI6ZVze4TWFw==
Date: Mon, 11 Oct 2010 19:11:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
In-Reply-To: <alpine.DEB.2.00.1010081255010.32749@router.home>
Message-ID: <alpine.DEB.2.00.1010111907190.27825@chino.kir.corp.google.com>
References: <20101008104852.803E.A69D9226@jp.fujitsu.com> <20101008090427.GB5327@balbir.in.ibm.com> <alpine.DEB.2.00.1010081044530.30029@router.home> <20101008165930.GH5327@balbir.in.ibm.com> <alpine.DEB.2.00.1010081255010.32749@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Christoph Lameter wrote:

> It implies that zone reclaim is going to be automatically enabled if the
> maximum latency to the memory farthest away is 3 times or more that of a
> local memory access.
> 

It doesn't determine what the maximum latency to that memory is, it relies 
on whatever was defined in the SLIT; the only semantics of that distance 
comes from the ACPI spec that states those distances are relative to the 
local distance of 10.
