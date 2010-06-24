Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0FXQc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:32:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43994 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab0FXQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:32:28 -0400
Date: Thu, 24 Jun 2010 18:32:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 50/52] mm: implement per-zone shrinker
Message-ID: <20100624163225.GT578@basil.fritz.box>
References: <20100624030212.676457061@suse.de>
 <20100624030733.676440935@suse.de>
 <87aaqkagn9.fsf@basil.nowhere.org>
 <20100624160052.GL10441@laptop>
 <20100624162702.GS578@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624162702.GS578@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 06:27:02PM +0200, Andi Kleen wrote:
> > > Overall it seems good, but I have not read all the shrinker callback
> > > changes in all subsystems.
> > 
> > Thanks for looking over it Andi.
> 
> FWIW i skimmed over most of the patches and nothing stood out that
> I really disliked. But I have gone over the code in very deep detail.

haven't

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
