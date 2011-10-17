Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1JQV0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:26:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1JQV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:26:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=vWl9slBiCWc+R+PTfEcOYhc4/GFKa6rkIb7phaw5UAODkEP8gGLUDOgL2UhrDVZC2
	UvoGoeyeIgaPcqrRxUhZA==
Date: Mon, 17 Oct 2011 14:26:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.2] tracing: various fixes
In-Reply-To: <1318882335.4722.13.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1110171424270.18439@chino.kir.corp.google.com>
References: <20111017174938.842273454@goodmis.org> <20111017185440.GB5545@elte.hu> <1318878632.4722.6.camel@gandalf.stny.rr.com> <20111017194030.GA6502@elte.hu> <1318881923.4722.11.camel@gandalf.stny.rr.com> <1318882335.4722.13.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Steven Rostedt wrote:

> > I could add it, but we should have an Acked-by from Hirokazu Takata.
> 
> 
> Here's the patch I'm referring to:
> 
> https://lkml.org/lkml/2011/10/13/259
> 
> Thanks!
> 

This patch makes my m32r cross-compiler happy, so for that:

Acked-by: David Rientjes <rientjes@google.com>

although the "Link:" field in that patch doesn't work for me.
