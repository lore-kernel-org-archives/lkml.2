Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab2JSLmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:42:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:47524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2JSLmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:42:14 -0400
Message-ID: <1350646894.30157.14.camel@twins>
Subject: Re: [PATCH 1/2] add credits for NUMA placement
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, aarcange@redhat.com
Date: Fri, 19 Oct 2012 13:41:34 +0200
In-Reply-To: <20121018171928.24d06af4@cuia.bos.redhat.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
	 <20121018171928.24d06af4@cuia.bos.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 17:19 -0400, Rik van Riel wrote:
> The NUMA placement code has been rewritten several times, but
> the basic ideas took a lot of work to develop. The people who
> put in the work deserve credit for it. Thanks Andrea & Peter :)
> 
> The Documentation/scheduler/numa-problem.txt file should
> probably be rewritten once we figure out the final details of
> what the NUMA code needs to do, and why.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks Rik!
