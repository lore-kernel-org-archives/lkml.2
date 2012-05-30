Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2E3Vam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:30:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56065 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2E3Val (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:30:41 -0400
Date: Wed, 30 May 2012 14:30:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@linux.intel.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <20120530163246.GF9850@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.00.1205301430001.9716@chino.kir.corp.google.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org> <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com> <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com> <alpine.LFD.2.02.1205300947180.2681@tux.localdomain>
 <alpine.DEB.2.00.1205301040170.29257@router.home> <20120530163246.GF9850@tassilo.jf.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Andi Kleen wrote:

> > > > Sigh, this was acked by Christoph and KOSAKI when the logic is reversed
> > > > and does the exact opposite of what's intended?
> > >
> > > Ping? Anyone going to send a fixed up patch?
> > 
> > I thought this was done and fixed in another email thread?
> 
> Yes the latest patch was final. But I can resend.
> 

Latest patch where?  The last patch posted in this thread had reversed 
logic.

Any idea why this isn't in today's linux-next if it was fixed in another 
thread?
