Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab0HCU4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:56:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61629 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0HCU4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:56:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IygZT0Szm1j/QCkrfHbKUvF2Kzvfb4JH+uW2DC8Ix1wXc6M6wOU4A/R2mUJ6A9Ir9
	PxheXbVqR3iAUvj3x2UhA==
Date: Tue, 3 Aug 2010 13:55:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        dave@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        jmorris@namei.org, sds@tycho.nsa.gov
Subject: Re: [PATCH] flex_array: add helpers to get and put to make pointers
 easy to use
In-Reply-To: <20100803193623.22126.18019.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.DEB.2.00.1008031351290.13924@chino.kir.corp.google.com>
References: <20100803193623.22126.18019.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Eric Paris wrote:

> Getting and putting arrays of pointers with flex arrays is a PITA.  You
> have to remember to pass &ptr to the _put and you have to do weird and
> wacky casting to get the ptr back from the _get.  Add two functions
> flex_array_get_ptr() and flex_array_put_ptr() to handle all of the magic.
> 

There's no code currently in the tree that uses the flex array interface, 
so is this something that you've encountered in practice or only by 
inspection?  If it's the former, is that code on its way for 2.6.36?

I'm hoping distros aren't creating internal dependencies on this interface 
that could practically be removed from upstream at any time given its lack 
of popularity.
