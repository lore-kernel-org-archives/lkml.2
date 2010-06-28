Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0F1Sqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:46:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0F1Sqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:46:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JZ+g/61WWHcgFCoIU6sV1eGomon00Z+rxSVrvMToqHgCrYbun1BM0/tj7YC4BrIwC
	+B4AS9hIs35ZX3Io56vDw==
Date: Mon, 28 Jun 2010 11:46:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] Makefile: fix missing dash when using make
 LOCALVERSION=xxx
In-Reply-To: <4C286A8F.9080508@redhat.com>
Message-ID: <alpine.DEB.2.00.1006281145590.25490@chino.kir.corp.google.com>
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain> <alpine.DEB.2.00.1006280207580.28072@chino.kir.corp.google.com> <4C286A8F.9080508@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Cong Wang wrote:

> But in your patch description, you said:
> 
>     Without CONFIG_LOCALVERSION_AUTO, "make" results in v2.6.32-rc4+
>     unless the repository is at the Linux v2.6.32-rc4 commit (in which
>     case the version would be v2.6.32-rc4).  If "make LOCALVERSION=kbuild"
>     were used, it results in v2.6.32-rc4-kbuild.
> 
> So, shouldn't that be "make LOCALVERSION=-kbuild"?
> 

Yup, that's what it should have said.  That doesn't mean that we need to 
change the long-standing behavior of LOCALVERSION= to add an implied `-', 
though.
