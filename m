Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1C3OUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:20:15 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:23821 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754812Ab1C3OUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:20:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ug1Z3BQVM1l.CQokVYBVYPjTejfaNujuJc90BIQp6I.8qAa
 JUM7z0aee59CHPaeiehzr8QNIAQIz1po7ZnpnVJLC9EmL6pDtaLTbk94BkI_
 WzBf5INLtF5nbx9G8WJJtUVUUj8DDa4nGcC4FFE8ExM3n4KlMJzNSOoc4t6z
 VbS0AzXgEY0AFpSwwFiqBuVJO5q0oRGd6.IzKNLqebWd9u5EJGK3QlFallz6
 LPOP27qUbdt9JILB8pWYKqNwVLaA0gBepB83Uj5mV6g7kGct46JY5bGQA4Bi
 0IBH9Lw7rjxdx_HtJFWlipga_jVnJyZdYcBIDlKY6JNc0HPb1
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 30 Mar 2011 09:20:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 3/3] acpi throttling: Use this_cpu_has and
 simplify code current cpu
In-Reply-To: <20110328164039.GF6736@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103300918240.25965@router.home>
References: <20110312115010.GC2005@htj.dyndns.org> <20110312115046.GD2005@htj.dyndns.org> <20110312115112.GE2005@htj.dyndns.org> <20110328164039.GF6736@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Tejun Heo wrote:

> On Sat, Mar 12, 2011 at 12:51:12PM +0100, Tejun Heo wrote:
> > From: Christoph Lameter <cl@linux.com>
> >
> > With the this_cpu_xx we no longer need to pass an acpi
> > structure to the msr management code. Simplifies code and improves
> > performance.
> >
> > NOTE: This code is x86 specific (see #ifdef CONFIG_X86) but not under
> >       arch/x86.
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> > Acked-by: Tejun Heo <tj@kernel.org>
> > ---
>
> Ingo, are you planning on picking these up?

Guess the patches missed the merge period. There could be more
optimizations of arch code if the infrastructure for this_cpu_has() would
be in but I guess I better hold off for awhile.

