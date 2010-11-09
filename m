Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0KIUWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:22:22 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36825 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0KIUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aJJm9BdxGYvC4GJgaRqe5rzos+7Splrt/CfEVCX1LxdSPnr+QaU+8MZ87jHiNUSu3r
         Mg6g+jqbUfEkJULB8KzS1Nzp17o2/vqlUg8Fy0hxomz12jOiePqkLAhZRoueO2b9pjeF
         vuo6FzyZuLIsvOVzkxyYvFFLD9thlDW9y29WM=
Date: Tue, 9 Nov 2010 23:22:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings v2
Message-ID: <20101109202215.GB4900@lenovo>
References: <1289251229-19589-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.00.1011082238420.2900@localhost6.localdomain6> <87oc9zqy0l.fsf@basil.nowhere.org> <20101108221528.GH6273@lenovo> <20101109015051.GC21551@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109015051.GC21551@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 02:50:51AM +0100, Andi Kleen wrote:
> > Well, Andi I proposed to define variable as u64 and convert it back to u32 at procedure
> > exit point. That would be clean, and I still think so ;) Though I'm fine with
> > either way (I just thought about ones who will be reading this code in future,
> > and since most the rdmsrl callers already use u64 and unsigned long, this would
> > be consistent as well).
> 
> I didn't use u64 because that would use more code on i386
> 
> -Andi

Fair enough. Thanks Andi.

  Cyrill
