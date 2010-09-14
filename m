Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0INFQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:16:34 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:55456 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0INFQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:16:33 -0400
Date: Tue, 14 Sep 2010 07:16:12 +0200
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: Valdis.Kletnieks@vt.edu
Cc: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100914051612.GA3247@pema>
References: <20100825094925.GA3632@pema>
 <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain>
 <20100826210815.GA18131@pema>
 <4C76D9A0.2010907@zytor.com>
 <20100829205929.GA3309@pema>
 <20100913100719.GA3903@pema>
 <54870.1284390647@localhost>
 <20100913152249.GC5364@const.bordeaux.inria.fr>
 <7925.1284428749@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7925.1284428749@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Valdis.Kletnieks@vt.edu (2010/09/13 21:45 -0400):
> I'm agreeing that if iris_init() checks that the user passed 'irisinit.force=1'
> on the command line or as a module parameter, and bailed immediately if it
> wasn't passed, then doing the inb() and testing it should be safe enough. Doing
> stuff that's only known safe on an Iris is no great sin if the user has said
> "Yes, you're on a Iris" - at that point it's the user's fault.

Fine. I'd be happy to submit another patch where the module takes a
force argument if that's okay to you guys.

Shérab.
