Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab2F1KEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:04:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab2F1KEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:04:22 -0400
Message-ID: <1340877845.28750.5.camel@twins>
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add tested-by signature
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 28 Jun 2012 12:04:05 +0200
In-Reply-To: <20120620143959.394b9930.akpm@linux-foundation.org>
References: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com>
	 <1340209526.29885.14.camel@joe2Laptop>
	 <20120620143959.394b9930.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 14:39 -0700, Andrew Morton wrote:
> Bug-spotted-by:
> Cause-discovered-by:
> Cautiously-acked-by:
> Checked-by:
> Committed-by:
> Compile-Tested-by:
> Compile-tested-by:
> Confirmed-by:
> Debugged-and-tested-by: 

You missed my favourite:

Commit 84599f8a59 carries:

  Chucked-on-by: Thomas Gleixner <tglx@linutronix.de>

[ although I must admit to it being a typo, in actual fact Thomas
  wanted to chuckle.. ]
