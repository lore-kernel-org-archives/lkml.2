Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab0JLMId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:08:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:50145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab0JLMIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:08:32 -0400
Subject: Re: [PATCH] dma: get_user_pages -> get_user_pages_fast
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101012115257.GA24389@redhat.com>
References: <20101011165310.GA5122@redhat.com>
	 <1286818496.1998.43.camel@laptop>  <20101012115257.GA24389@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 14:08:24 +0200
Message-ID: <1286885304.29097.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 13:52 +0200, Michael S. Tsirkin wrote:
> We probably should set a limit on the number of pages, too:
> currently there could be a large # of very small chunks in the iovec.

Well, there's also the gup_fast batch stuff that I keep forgetting to
push:

 http://lkml.org/lkml/2009/6/24/457

Which would solve that part.
