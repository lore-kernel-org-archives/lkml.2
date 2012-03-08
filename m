Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2CHLyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:54:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab2CHLyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:54:06 -0500
Message-ID: <4F589DD7.1040704@redhat.com>
Date: Thu, 08 Mar 2012 13:53:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 7 (kvm)
References: <20120307181009.bc377d39ae4f1d575305c693@canb.auug.org.au> <4F57E791.6070205@xenotime.net>
In-Reply-To: <4F57E791.6070205@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 12:56 AM, Randy Dunlap wrote:
> On 03/06/2012 11:10 PM, Stephen Rothwell wrote:
>
> > Hi all,
> > 
> > Changes since 20120306:
> > 
> > The kvm tree lost its build failure.
>
>
> I'm getting this build error on X86_32 (i386):
>
> arch/x86/kvm/x86.c:1042: Error: no instruction mnemonic suffix given and no register operands; can't size instruction
>
>

Patch to follow.

-- 
error compiling committee.c: too many arguments to function

