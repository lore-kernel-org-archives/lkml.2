Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab0CRQrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:47:24 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:37088 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0CRQrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:47:23 -0400
Date: Thu, 18 Mar 2010 11:31:39 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 01/11] mm,migration: Take a reference to the anon_vma
 before migrating
In-Reply-To: <20100318111231.GJ12388@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003181131310.22889@router.home>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie> <1268412087-13536-2-git-send-email-mel@csn.ul.ie> <20100317103434.4C8B.A69D9226@jp.fujitsu.com> <20100317114537.GF12388@csn.ul.ie> <alpine.DEB.2.00.1003171138070.27268@router.home>
 <20100318111231.GJ12388@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010, Mel Gorman wrote:

> Then even if we move to a full ref-count, it might still be a good idea
> to preserve the SLAB_DESTROY_BY_RCU.

Yes.

