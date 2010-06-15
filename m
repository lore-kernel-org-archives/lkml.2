Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0FOM4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:56:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:37607 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0FOM4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:56:53 -0400
Date: Tue, 15 Jun 2010 08:56:50 -0400
From: tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@google.com, torvalds@linux-foundation.org,
       walken@google.com, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100615125650.GL6666@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Salman <sqazi@google.com>, mingo@elte.hu,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	tytso@google.com, torvalds@linux-foundation.org, walken@google.com,
	Chen Liqin <liqin.chen@sunplusct.com>,
	Lennox Wu <lennox.wu@gmail.com>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
 <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
 <20100614165851.6bdfe485.akpm@linux-foundation.org>
 <20100615005619.GI6666@thunk.org>
 <20100614185556.afdc5304.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614185556.afdc5304.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 06:55:56PM -0700, Andrew Morton wrote:
> 
> I think you're probably right, as long as one sticks with 4-byte
> scalars.  The cmpxchg-is-now-generic change snuck in under the radar
> (mine, at least).

Hmmm, what about unsigned longs?  (Which might be 8 bytes on some
architectures....)

					- Ted
