Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1DMB1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:27:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1DMB1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:27:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fUa5OT9fmAiGYCdOeHcrY8E7tq9+nMRiCLeKAO61AaeGhcG0rL6/pRW9wza8ISuz9H
         KPbuEjftcSCElBGhPboA==
Date: Tue, 12 Apr 2011 18:27:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joerg Roedel <joro@8bytes.org>
cc: Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@elte.hu>,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.39-rc3
In-Reply-To: <20110412184433.GF19819@8bytes.org>
Message-ID: <alpine.DEB.2.00.1104121825020.13390@chino.kir.corp.google.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Joerg Roedel wrote:

> Bisecting actually gave a very weird result. It points to
> 
> 	d2137d5af4259f50c19addb8246a186c9ffac325
> 
> which is a merge-commit in the x86 tree. Even more weird is that this
> notebook is the only machine with these symptoms, all my other boxes are
> fine.
> During the bisect I tested commits from Yinghai which were good. It
> seems like the problem appeared with the merge.
> 

Alexandre Demers (cc'd) reports a boot failure bisected to the same merge 
on a 64-bit AMD tricore in 
https://bugzilla.kernel.org/show_bug.cgi?id=33012.  We're awaiting 
earlyprintk= output from that kernel, if possible, and Yinghai asked for 
his .config and dmesg output from the last known working kernel.
