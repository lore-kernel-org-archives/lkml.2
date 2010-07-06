Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0GFOYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 10:24:38 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:50972 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0GFOYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 10:24:37 -0400
Date: Tue, 6 Jul 2010 09:22:22 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au, dhowells@redhat.com,
       arjan@linux.intel.com, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
In-Reply-To: <4C2A1ABF.8050504@kernel.org>
Message-ID: <alpine.DEB.2.00.1007060921350.3627@router.home>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29A33D.2060407@kernel.org> <20100629123632.GB5318@nowhere> <4C2A145E.8030608@kernel.org> <20100629154738.GJ5318@nowhere>
 <4C2A1672.20700@kernel.org> <20100629160100.GL5318@nowhere> <4C2A1ABF.8050504@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010, Tejun Heo wrote:

> What alignment maintenance?  Are you talking about the UP code?  If
> you're talking about the UP code, the ugliness there is because the
> current UP __alloc_percpu() can't honor the alignment parameter.

Why do we need alignment on UP? Cachelines typically dont bounce if a
single processor accesses the data.

