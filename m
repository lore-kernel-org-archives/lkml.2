Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab1ADWaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:30:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab1ADWaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:30:19 -0500
Date: Tue, 4 Jan 2011 19:03:07 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        riel@redhat.com, gleb@redhat.com, avi@redhat.com,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] kvm: Fix section mismatch derived from
 kvm_guest_cpu_online()
Message-ID: <20110104210307.GB6130@amt.cnet>
References: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 12:01:29AM +0100, Sedat Dilek wrote:
> >From my build.log:
> 
> WARNING: arch/x86/built-in.o(.text+0x1bb74): Section mismatch in reference from the function kvm_guest_cpu_online() to the function .cpuinit.text:kvm_guest_cpu_init()
> The function kvm_guest_cpu_online() references
> the function __cpuinit kvm_guest_cpu_init().
> This is often because kvm_guest_cpu_online lacks a __cpuinit
> annotation or the annotation of kvm_guest_cpu_init is wrong.
> 
> This patch fixes the warning.
> 
> Tested with linux-next (next-20101231)
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

Applied, thanks.

