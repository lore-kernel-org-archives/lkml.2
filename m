Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935423Ab1IOX0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:26:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:47537 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab1IOX0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:26:15 -0400
Date: Fri, 16 Sep 2011 01:26:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Josh Boyer <jwboyer@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
In-Reply-To: <20110915205709.GB7761@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109160118320.2723@ionos>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org> <1316117394-21666-8-git-send-email-andi@firstfloor.org> <CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com> <4E726489.6080606@linux.intel.com>
 <CA+5PVA52Q+9jBbF7fdjDgpkv9rAwPKgyH+34zMPxYXusn-LctQ@mail.gmail.com> <20110915205709.GB7761@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1838296879-1316129173=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1838296879-1316129173=:2723
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 15 Sep 2011, Andi Kleen wrote:

> On Thu, Sep 15, 2011 at 04:56:04PM -0400, Josh Boyer wrote:
> > On Thu, Sep 15, 2011 at 4:48 PM, Andi Kleen <ak@linux.intel.com> wrote:
> > > On 9/15/2011 1:45 PM, Josh Boyer wrote:
> > >>
> > >> On Thu, Sep 15, 2011 at 4:09 PM, Andi Kleen<andi@firstfloor.org>  wrote:
> > >>>
> > >>> From: Andi Kleen<ak@linux.intel.com>
> > >>>
> > >> What's the problem again?
> > >
> > > It's wrong. For more details see 0/*
> > 
> > Do you have an example of the compiler/linker erroring out?
> 
> You currently need a special toolkit set up for this, it doesn't 
> happen in normal builds. ...

Can you please provide the answer to the question which was asked ?

It does not matter at all whether you need a special toolkit or
not. Josh explicitely asked for an error output example.

> ....  It's still wrong however.

So we have to trust special toolkit setups and your infamous
impeccability?

Definitely not!

Start providing proper information instead of snotty and useless
lumps.

No thanks,

   tglx
--8323328-1838296879-1316129173=:2723--
