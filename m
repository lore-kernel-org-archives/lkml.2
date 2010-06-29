Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0F2Prb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:47:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59542 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab0F2Pr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LtQTFCKdpufF08dxKR8n8VMMhMAaWhUn/jfNJlpEpAVV3OjhvWgAYTlbfhkNmdmL16
         kxvY7n1Km+156bLrzVSPgLAwsWL/LU3kVg9HOnDfWCVWRNC40vw/ef/SMOt+Zqb7Dxcz
         hm5b0Ted4GJzxUBrV9UInAGZRGWYeaoHy92Jc=
Date: Tue, 29 Jun 2010 17:47:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
Message-ID: <20100629154738.GJ5318@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29A33D.2060407@kernel.org> <20100629123632.GB5318@nowhere> <4C2A145E.8030608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2A145E.8030608@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 05:42:22PM +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/29/2010 02:36 PM, Frederic Weisbecker wrote:
> > But then, if each cpu pointers are aligned, the struct itself doesn't need
> > to be aligned in its size right? It would need to if multiple elements
> > were allocated per cpu but for this struct we only have one per cpu. So
> > what seems to matter wrt alignment is only the base pointer of these structs,
> > not the size.
> 
> Yeap, sure, but how does it matter?


It means the size of the struct itself doesn't need to aligned to anything.

