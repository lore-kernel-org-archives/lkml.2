Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab2GBKqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:46:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56844 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab2GBKqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:46:14 -0400
Date: Mon, 2 Jul 2012 13:46:09 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Glauber Costa <glommer@parallels.com>
cc: Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, sfr@canb.auug.org.au, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab: Fix a tpyo in commit 8c138b "slab: Get rid of
 obj_size macro"
In-Reply-To: <4FF17733.6020703@parallels.com>
Message-ID: <alpine.LFD.2.02.1207021346030.1916@tux.localdomain>
References: <1341210550-11038-1-git-send-email-feng.tang@intel.com> <4FF1714A.7050400@parallels.com> <4FF17733.6020703@parallels.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, Glauber Costa wrote:
> > I saw another bug in a patch that ended up not getting in, and was
> > reported to Christoph, that was exactly due to a typo between size and
> > object-size.
> > 
> > So first:
> > 
> > Acked-by: Glauber Costa <glommer@parallels.com>
> > 
> > But this also means that that confusion can have been made in other
> > points. I suggest we take an extensive look into that to make sure there
> > aren't more.
> > 
> 
> Which I just did. I also tried to pay attention to another simple
> conversion spots like that. We seem to be fine.

Applied, thanks guys!
