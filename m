Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0CXN2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:28:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:50512 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab0CXN2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:28:21 -0400
Subject: Re: [rfc][patch] mm: lockdep page lock
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100316022153.GJ2869@laptop>
References: <20100315155859.GE2869@laptop>
	 <20100315180759.GA7744@quack.suse.cz>  <20100316022153.GJ2869@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 14:28:11 +0100
Message-ID: <1269437291.5109.238.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 13:21 +1100, Nick Piggin wrote:
> 
> 
> Agreed (btw. Peter is there any way to turn lock debugging back on?
> it's annoying when cpufreq hotplug code or something early breaks and
> you have to reboot in order to do any testing).

Not really, the only way to do that is to get the full system back into
a known (zero) lock state and then fully reset the lockdep state.

It might be possible using the freezer, but I haven't really looked at
that, its usually simpler to simply fix the offending code or simply not
build it in your kernel.


