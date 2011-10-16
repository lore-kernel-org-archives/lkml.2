Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1JPAx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 20:53:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1JPAx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 20:53:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=eix7niUrcQHbDCAgvHU1vGmGHYf6UZ02OUcYHu9ajvY5ng2A52CKp7hqa3/pUXrar
	l+7ivEXt3eUEUTr9H+Hyw==
Date: Sat, 15 Oct 2011 17:53:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Please include const-sections into linux-next
In-Reply-To: <1318722567.7271.56.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.00.1110151752060.5728@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org> <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1110151543220.25063@chino.kir.corp.google.com> <1318722567.7271.56.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, James Bottomley wrote:

> I think it's probably a compiler bug.  gcc isn't as adept with section
> annotations as people think it is.  This tends to manifest in the
> non-x86 toolchains because we tend to be using earlier versions.
> 

It compiles fine with my cross-compiler using gcc-4.5.1.
