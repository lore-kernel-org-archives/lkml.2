Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab0HCWnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:43:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:41913 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab0HCWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:43:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nN9qwoZK1rj1NBgkcWSDdaHbYnZYZzPiSd8vc+f+Ym/IERwBt6dDt0SE+e8n+hiKg
	wHk4ACASAdpbBbqsgRMXQ==
Date: Tue, 3 Aug 2010 15:43:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        dave@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        jmorris@namei.org, sds@tycho.nsa.gov
Subject: Re: [PATCH] flex_array: add helpers to get and put to make pointers
 easy to use
In-Reply-To: <1280873146.23348.7.camel@dhcp231-200.rdu.redhat.com>
Message-ID: <alpine.DEB.2.00.1008031540510.25322@chino.kir.corp.google.com>
References: <20100803193623.22126.18019.stgit@paris.rdu.redhat.com> <alpine.DEB.2.00.1008031351290.13924@chino.kir.corp.google.com> <1280873146.23348.7.camel@dhcp231-200.rdu.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Eric Paris wrote:

> > > Getting and putting arrays of pointers with flex arrays is a PITA.  You
> > > have to remember to pass &ptr to the _put and you have to do weird and
> > > wacky casting to get the ptr back from the _get.  Add two functions
> > > flex_array_get_ptr() and flex_array_put_ptr() to handle all of the magic.
> > > 
> > 
> > There's no code currently in the tree that uses the flex array interface, 
> > so is this something that you've encountered in practice or only by 
> > inspection?  If it's the former, is that code on its way for 2.6.36?
> 
> I did decide to use flex_arrays on code intended for .36
> http://git.kernel.org/?p=linux/kernel/git/jmorris/security-testing-2.6.git;a=commitdiff;h=6371dcd36f649d9d07823f31400618155a20dde1
> 

Great, a user!  I'm hoping that more people will adopt this interface but 
I can't think of anything that could currently be converted.  Maybe we can 
find opportunities in patches as they're proposed to the list.

Thanks.
