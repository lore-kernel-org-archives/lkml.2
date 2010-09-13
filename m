Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0IMPZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:25:44 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:45606 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0IMPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:25:42 -0400
Date: Mon, 13 Sep 2010 17:25:11 +0200
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: Valdis.Kletnieks@vt.edu
Cc: "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100913152511.GA3916@pema>
References: <20100825094925.GA3632@pema>
 <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain>
 <20100826210815.GA18131@pema>
 <4C76D9A0.2010907@zytor.com>
 <20100829205929.GA3309@pema>
 <20100913100719.GA3903@pema>
 <54870.1284390647@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54870.1284390647@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Is it actually safe to assume that this will do the right thing on a machine that
> is a non-Iris that has something *else* at that I/O  address?

No it's probably not safe.

> Any further sanity checking we can do?

I have asked the manufacturer and will be happy to provide patches to
implement them but I doubt there will be some.

> (For that matter, are there machines that will get indigestion
> at this sort of unexpected inb() access?)

That, I don't know.

Shérab.
