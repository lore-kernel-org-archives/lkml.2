Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1KFT6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:58:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:45339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1KFT6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:58:12 -0500
Subject: Re: REGRESSION: "perf: Add PM notifiers ..." breaks resume
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, rjw@sisk.pl
Date: Sun, 06 Nov 2011 20:57:06 +0100
In-Reply-To: <CA+55aFwCf41GFOVA656-ZgZB5mBNkpH3KqRfJ_Ornkn3RWF5gQ@mail.gmail.com>
References: <20111102134900.GB4377@one.firstfloor.org>
	 <CA+55aFwCf41GFOVA656-ZgZB5mBNkpH3KqRfJ_Ornkn3RWF5gQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320609426.30279.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 17:00 -0700, Linus Torvalds wrote:
> Peter, Ingo, ping?
> 
> 
Shoot it.. I'll poke at it later and try and solve the thing
differently.
