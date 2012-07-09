Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2GIJKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:10:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45085 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2GIJJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:09:59 -0400
Date: Mon, 9 Jul 2012 12:09:54 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: JoonSoo Kim <js1304@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Christoph Lameter <cl@linux.com>, Rus <rus@sfinxsoft.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: __GFP_FS allocations with IRQs disabled
 (kmemcheck_alloc_shadow)
In-Reply-To: <alpine.DEB.2.00.1207081558540.18461@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1207091209220.3050@tux.localdomain>
References: <20120708040009.GA8363@localhost> <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com> <alpine.DEB.2.00.1207081558540.18461@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012, David Rientjes wrote:
> The correct fix is what I proposed at 
> http://marc.info/?l=linux-kernel&m=133754837703630 and was awaiting 
> testing.  If Rus, Steven, or Fengguang could test this then we could add 
> it as a stable backport as well.

Looks good to me. Care to send it my way at penberg@kernel.org? It looks 
like people CC'd me as "penberg@cs.helsinki.fi" which is why I missed it.

			Pekka
