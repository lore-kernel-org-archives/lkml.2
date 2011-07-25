Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1GYMcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:32:41 -0400
Received: from ozlabs.org ([203.10.76.45]:37047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1GYMcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:32:35 -0400
Date: Mon, 25 Jul 2011 22:32:32 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net,
        linux-kernel@vger.kernel.org, amodra@gmail.com
Subject: Re: [PATCH] perf: Fix symbol resolution on old ppc64 ABI
Message-ID: <20110725223232.4e2dce43@kryten>
In-Reply-To: <20110725105004.GN28787@elte.hu>
References: <20110725142356.0c722c6b@kryten>
	<20110725062542.GA694@elte.hu>
	<20110725204859.51e50611@kryten>
	<20110725105004.GN28787@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

> > It would cover most cases. There would be an issue with functions 
> > that are less than 24 bytes in length (ie 6 instructions). Tiny 
> > functions are probably rare enough that we can live with it.
> 
> Do such tiny functions get packed tightly, below 24 bytes? Another 
> sanitization pass could solve that issue, to trim partially 
> overlapping symbol regions, right?

That would work I think. Should I cook up a patch?

Anton
