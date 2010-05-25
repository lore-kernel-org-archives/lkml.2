Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0EYJpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:45:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab0EYJpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:45:46 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: piotr@hosowicz.com
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Divyesh Shah <dpshah@google.com>
In-Reply-To: <4BFB9B6E.9090402@example.com>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <4BFB9B6E.9090402@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 11:45:40 +0200
Message-ID: <1274780740.5882.726.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 11:42 +0200, Piotr Hosowicz wrote:
> On 25.05.2010 10:50, Peter Zijlstra wrote:
> 
> > Clearly nobody tested this, and its terribly broken to boot.
> >
> > I guess they want something like:
> 
> Patch applied, building now. Why don't you merge this into the kernel 
> tree? Or should I apply this patch each time manually?

It should appear in a tree near you 'soon' :-)

The way things work I don't actually have commit access to Linus' tree,
but I'll pass the patch to Ingo, who will put it in -tip, which will
then be send Linus wards.


