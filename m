Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1CBH2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:28:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38912 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1CBH2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:28:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hpuLWc7qfLWxtAF2gUPU6O30haJKZi2jIT1GUz7B+/43daa1fwmpGSWl6tfUTJ8rt4
         P7ZhA+hcNk77tujhwX+rbOsw0TuhscexOGFhZshMBWYF+tJxL2IHrKwKgo5Om6FPjxmg
         QQQRr58K5z4jgZa8W8uXzCv4a5ku6d5T/QJgc=
Date: Wed, 2 Mar 2011 08:28:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302072848.GB19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110301190638.GA12196@host1.dyn.jankratochvil.net>
 <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 01, 2011 at 11:14:14PM +0100, Denys Vlasenko wrote:
> There may be reasons to have PTRACE_SEIZE operation split like that.
> For one, this allows debugger to do PTRACE_CONT, and later issue
> PTRACE_INTERRUPT to stop the tracee again. PTRACE_INTERRUPT stop may
> be better for some scenarios where debugger wants to make the stop
> invisible to the parent, or when debugger wants to stop just one
> thread of the process.

PTRACE_SEIZE can be used like PTRACE_INTERRUPT.  It works whether the
tracee is attached or not.

Thanks.

-- 
tejun
