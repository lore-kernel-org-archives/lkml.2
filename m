Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0L3BIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 20:08:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35419 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0L3BH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 20:07:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Mkqq4iatMbvwbau3Puobgs8n8/rDml86LdZ5OOexD8M2Fz36bR3VJ+hP4JTuiHwith
         ffeCeluUDhHP78ose6PA==
Date: Wed, 29 Dec 2010 17:07:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable to local node
 memory
In-Reply-To: <4D1BD928.50701@zytor.com>
Message-ID: <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org> <4D1933D1.9020609@kernel.org> <4D1BC856.4010202@kernel.org> <4D1BC94C.5040100@zytor.com> <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com> <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>
 <4D1BD928.50701@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010, H. Peter Anvin wrote:

> > That's from f51bf3073a1 (x86, numa: Fake apicid and pxm mappings for NUMA 
> > emulation) and c1c3443c9c (x86, numa: Fake node-to-cpumask for NUMA 
> > emulation) in x86/numa.  Given the subject line, I think your patchset is 
> > targeted to the same branch so I'm not sure what's concerning?
> 
> No, it's part of a much bigger patchset which doesn't have anything to
> do with NUMA.  That's the problem.
> 
> In other words, I need a sane way to merge them and resolve the conflict.
> 

The two patches above from x86/numa that create the conflict should be 
dependent only on 4e76f4e67a (x86, numa: Avoid compiling NUMA emulation 
functions without CONFIG_NUMA_EMU), so cherry-pick them into x86/bootmem?
