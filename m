Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2DOLS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:18:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52270 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2DOLSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:18:25 -0400
Message-ID: <1334488687.28150.3.camel@twins>
Subject: Re: Using nested locking for spin_lock_bh
From: Peter Zijlstra <peterz@infradead.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        simon.wunderlich@s2003.tu-chemnitz.de,
        Marek Lindner <lindner_marek@yahoo.de>
Date: Sun, 15 Apr 2012 13:18:07 +0200
In-Reply-To: <2108147.Aqyix6xDmB@bentobox>
References: <2108147.Aqyix6xDmB@bentobox>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 18:36 +0200, Sven Eckelmann wrote:
> 
> Is there another way how this should be done or is there a general problem why 
> there is no nested support for this incarnation of spin_lock? 

No reason other than that it wasn't needed before now, but I see you've
resolved things with a lockdep_set_class() which works too.


