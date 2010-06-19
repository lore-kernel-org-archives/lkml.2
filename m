Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0FSTxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:53:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52037 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab0FSTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:53:47 -0400
Date: Sat, 19 Jun 2010 21:53:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] use kexec_kernel.h for the kernel-only stuff [Was:
 [PATCH] Export kexec.h]
Message-ID: <20100619195345.GT18946@basil.fritz.box>
References: <20100619132235.GA24200@basil.fritz.box>
 <20100619182419.GA22079@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619182419.GA22079@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 08:24:19PM +0200, Sam Ravnborg wrote:
> On Sat, Jun 19, 2010 at 03:22:35PM +0200, Andi Kleen wrote:
> > Export kexec.h
> >     
> > kexec_load is a system call and it needs a header
> > file with its input arguments.
> > 
> > Export the parts of kexec.h needed for this.
> 
> Rather than introducing yet another file where
> only a fraction is exported how about a split
> where we put the kernel specific definitions in kexec_kernel.h.
> And kexec.h is the userspace interface (which is included
> by kexec_kernel.h).
> 
> We did it like this for pps some time ago.

Would work for me too, I have no strong opinion either way.

Being naturally lazy, I just went with the simpler patch
myself.

-Andi
