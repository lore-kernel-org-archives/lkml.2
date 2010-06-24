Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0FXQ1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:27:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53727 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0FXQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:27:04 -0400
Date: Thu, 24 Jun 2010 18:27:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 50/52] mm: implement per-zone shrinker
Message-ID: <20100624162702.GS578@basil.fritz.box>
References: <20100624030212.676457061@suse.de>
 <20100624030733.676440935@suse.de>
 <87aaqkagn9.fsf@basil.nowhere.org>
 <20100624160052.GL10441@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624160052.GL10441@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Overall it seems good, but I have not read all the shrinker callback
> > changes in all subsystems.
> 
> Thanks for looking over it Andi.

FWIW i skimmed over most of the patches and nothing stood out that
I really disliked. But I have gone over the code in very deep detail.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
