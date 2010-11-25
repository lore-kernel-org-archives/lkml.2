Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0KYN5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:57:37 -0500
Received: from smtp-in.kfki.hu ([148.6.0.25]:47425 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab0KYN5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:57:35 -0500
Date: Thu, 25 Nov 2010 14:57:34 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@medozas.de>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] Prepare the tree for un-inlined jhash.
In-Reply-To: <alpine.LNX.2.01.1011251439160.21752@obet.zrqbmnf.qr>
Message-ID: <alpine.DEB.2.00.1011251454430.996@blackhole.kfki.hu>
References: <1290690908-794-1-git-send-email-kadlec@blackhole.kfki.hu> <1290690908-794-2-git-send-email-kadlec@blackhole.kfki.hu> <alpine.LNX.2.01.1011251439160.21752@obet.zrqbmnf.qr>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Jan Engelhardt wrote:

> On Thursday 2010-11-25 14:15, Jozsef Kadlecsik wrote:
> 
> >jhash is widely used in the kernel and because the functions
> >are inlined, the cost in size is significant. Also, the new jhash
> >functions are slightly larger than the previous ones so better un-inline.
> >As a preparation step, the calls to the internal macros are replaced
> >with the plain jhash function calls.
> 
> Do you have a non-normative allyesconfig/allmodconfig build whose 
> size(1) you can run on, to show approximately just how much it differs?

In the cover mail I referred the link to the message from Ilpo Jarvinen: 
"I once looked into inlining cost and jhash functions were among the most 
wasteful (kernel-wide). Multiple jhash bodies were 100+ bytes, and the 
overall cost was 10k+."

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
