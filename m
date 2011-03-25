Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1CYPlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:41:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35048 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1CYPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:41:21 -0400
Date: Fri, 25 Mar 2011 16:41:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Alessio Igor Bogani <abogani@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ian Lance Taylor <ian@airs.com>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for locate the symbols
Message-ID: <20110325154118.GN21838@one.firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org> <1300914043-2297-3-git-send-email-abogani@kernel.org> <m27hbov7hq.fsf@firstfloor.org> <8739mblr2n.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739mblr2n.fsf@rustcorp.com.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 03:44:24PM +1030, Rusty Russell wrote:
> On Thu, 24 Mar 2011 08:54:57 -0700, Andi Kleen <andi@firstfloor.org> wrote:
> > Alessio Igor Bogani <abogani@kernel.org> writes:
> > 
> > > This work was supported by a hardware donation from the CE Linux Forum.
> > 
> > Patch looks good to me. SORT is a nice trick, too bad it won't 
> > work for the main kernel.
> 
> Why not?

Because kallsyms is supposed to be in address order, not name order.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
