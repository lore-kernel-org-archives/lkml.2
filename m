Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1I3E6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:58:25 -0400
Received: from 1wt.eu ([62.212.114.60]:33287 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab1I3E6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:58:24 -0400
Date: Fri, 30 Sep 2011 06:58:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS cpu scheduler and skip list implementation
Message-ID: <20110930045815.GB8592@1wt.eu>
References: <201109240945.58879.kernel@kolivas.org> <201109241838.06941.kernel@kolivas.org> <20110929204505.GA8810@1wt.eu> <201109300858.28633.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109300858.28633.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:58:28AM +1000, Con Kolivas wrote:
> In fact after I fixed a few bugs in the original implementation I posted here, 
> and cleaned up the code to not do dynamic memory allocation in the hot 
> scheduler path and so on... I found it (my skip list implementation) to be 
> universally slower than the existing BFS approach of simple linked lists and 
> walking the list for lookup.

People often underestimate how fast simple lists can be on small to medium
data sets :-)

> Any performance advantage in the original version 
> was coincidence due to the way it performed on one workload and was bad in 
> others. Rather disappointing but you can read my thoughts here
> 
> http://ck-hack.blogspot.com/

Well, this coincidence at least shows something : by avoiding some work
and by possibly being unfair to some non-critical tasks, you managed
to reduce the time it takes to run a given workload. That's what many
scientists call an accidental experimentation. Now you need to find how
to get close to those numbers without the downsides you've explained on
the link above :-)

> Anyway I'll make sure to read your code and see if it has anything to offer 
> me. Thanks for the pointer.

OK. Do not hesitate to ping me if you need some help when playing with
the code. I might even still have a backup of the wikipedia article I
wrote at that time when some users asked me, and that was deleted by
some bastards^Wmoderators, who considered it was just self promotion!
There were a few diagrams there which explain how that works.

Best regards,
Willy

