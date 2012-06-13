Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2FMONJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:13:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:49295 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2FMONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:13:07 -0400
Date: Wed, 13 Jun 2012 16:13:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
In-Reply-To: <20120613133855.GA32428@gmail.com>
Message-ID: <alpine.LFD.2.02.1206131611400.3086@ionos>
References: <20120522032554.GA11358@gmail.com> <Pine.LNX.4.64.1206121201130.6800@axis700.grange> <alpine.LFD.2.02.1206121639420.3086@ionos> <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com> <alpine.LFD.2.02.1206121732230.3086@ionos>
 <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com> <alpine.LFD.2.02.1206131127050.3086@ionos> <20120613133855.GA32428@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Ingo Molnar wrote:
> Seems like the least invasive option to me. It's not like we are 
> in a rush to break more stuff.

OTOH, when will we get the chance again to break lots of stuff Par
ordre de Mufti?
