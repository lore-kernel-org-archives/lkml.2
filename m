Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1JRIHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:07:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1JRIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:07:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=lV6qnectN840I4RBhMEZvd4fVjYc29icpIldxiUMPplQFF5mTr+LiB4gZQ/BCMNgJ
	qMeU0VtKnmxYQuJRFHoDA==
Date: Tue, 18 Oct 2011 01:07:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Hellwig <hch@infradead.org>
cc: Josh Boyer <jwboyer@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
In-Reply-To: <20111018065852.GA6056@infradead.org>
Message-ID: <alpine.DEB.2.00.1110180105080.8959@chino.kir.corp.google.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com> <20111018065852.GA6056@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Christoph Hellwig wrote:

> > The stable@kernel.org email address has been replaced with the
> > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> > reference the new list instead of the semi-defunct email alias.
> 
> Does this mean it already stopped working?  I recently sent pathces
> there but neither got an ACK nor a bounce or similar.
> 

It was bouncing (and noticably so) as of a week ago but I believe hpa has 
since setup an alias to point to stable@vger.kernel.org.  Linus cc'd his 
own commit to it yesterday, a84a79e4d369, so as long as you didn't get a 
bounce email it should have gone through.

 [ I believe Greg also has gone through everything with a
   "Cc: stable@kernel.org" in Linus' tree as well, either automatically 
   or because of the bounces. ]
