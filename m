Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1DFVbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:31:42 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:44260 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab1DFVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:31:40 -0400
From: Richard Weinberger <richard@nod.at>
To: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] [RFC] um: x86: unbreak build by reintroducing this_cpu_cmpxchg16b_emu
Date: Wed, 6 Apr 2011 23:31:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20110407001837.12e6f01c@sf.home>
In-Reply-To: <20110407001837.12e6f01c@sf.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104062331.34205.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei,

Am Mittwoch 06 April 2011, 23:18:37 schrieb Sergei Trofimovich:
> I'm sure fix can be nices, but initial patch should express an idea.

Please send patches not as attachment.

I think this patch is only needed on x86_64.
Um builds fine on my main machine (i386).
It seems to fail on x86_64 when using  CONFIG_SLUB=y.

> The main offender is privileged 'cli'.
> 
> Thanks!

Thanks,
//richard

