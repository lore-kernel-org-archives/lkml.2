Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2E3Grn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:47:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37271 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2E3Grm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:47:42 -0400
Date: Wed, 30 May 2012 09:47:37 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, cl@linux.com
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1205300947180.2681@tux.localdomain>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org> <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com> <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, David Rientjes wrote:
> > But this doesn't mean NAK anyway.
> > 
> >  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Sigh, this was acked by Christoph and KOSAKI when the logic is reversed 
> and does the exact opposite of what's intended?

Ping? Anyone going to send a fixed up patch?
