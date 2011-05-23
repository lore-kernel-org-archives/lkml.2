Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1EWCbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:31:39 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:37490 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab1EWCbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lZEA7f8FOUEhbtPqGowXpGVeYZi3rzusfAd0q9pqy5X1+s1bXRNMr9GBV5+utMsqEB
         zMTRxdi/DOTop3ofk6iPEYV6rmuCp9ZzBlS8dOqDldMlQIr1gddVBbSKP9aLXSjxRlOm
         SM+2owpFJZA8+EZqAo8XNHkLYhY5YkvPhyNK8=
MIME-Version: 1.0
In-Reply-To: <20110523112529.c2dbc445.sfr@canb.auug.org.au>
References: <20110523112529.c2dbc445.sfr@canb.auug.org.au>
Date: Sun, 22 May 2011 22:31:36 -0400
Message-ID: <BANLkTimq+cFfHYx183v_RvH6hAaOmJZ-Mg@mail.gmail.com>
Subject: Re: linux-next: build warnings in Linus' tree
From: Eduardo Silva <edsiper@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 9:25 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the origin tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
>
> arch/x86/kernel/ftrace.c: In function 'ftrace_make_nop':
> arch/x86/kernel/ftrace.c:308: warning: assignment discards qualifiers from pointer target type
> arch/x86/kernel/ftrace.c: In function 'ftrace_make_call':
> arch/x86/kernel/ftrace.c:318: warning: assignment discards qualifiers from pointer target type

discussing ftrace.c warnings on this thread:

   https://lkml.org/lkml/2011/5/22/158

regards,


>
> Introduced by commit dc326fca2b64 ("x86, cpu: Clean up and unify the NOP
> selection infrastructure").
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Eduardo Silva
http://edsiper.linuxchile.cl
http://www.monkey-project.com
