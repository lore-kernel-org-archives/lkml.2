Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2HCUXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:23:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56159 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2HCUXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <1343976472.1730.18.camel@sauron.fi.intel.com>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
 <1343976472.1730.18.camel@sauron.fi.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Aug 2012 13:23:29 -0700
X-Google-Sender-Auth: qZZyMfARnnR-0DuSEECRnnpmV58
Message-ID: <CA+55aFz322dKXUwtmrrW=nfp5XJa5ACh1syE8RXOOdcA7V_76A@mail.gmail.com>
Subject: Re: Linux 3.6-rc1
To: dedekind1@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 11:47 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>
> We have had 11 of 13 pieces of the 'sync_supers()' removal patch-sets
> merged. The 12th piece removes dead code in exofs was supposed to go
> through the exofs tree and blocked the 13th piece which removes
> 'sync_supers()' and was supposed to go via the VFS tree.
>
> Both 12th and 13th pieces zap dead code. I man not sure delaying that to
> v3.7 would be very beneficial for the kernel (why having a useless
> thread waking up every 5 secs?). Would you let us merge this to -rc1?

Ok. I'm pulling the exofs changes, they're small and remove more lines
than they add. And if the last piece then just kills dead code, I
won't mind that either.

           Linus
