Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2CLUi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:38:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:40052 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab2CLUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:38:56 -0400
Message-ID: <1331584704.3105.89.camel@pasglop>
Subject: Re: [PATCH 21/29] Disintegrate asm/system.h for PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, arnd@arndb.de,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Date: Tue, 13 Mar 2012 07:38:24 +1100
In-Reply-To: <20120307194948.15987.95344.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
	 <20120307194948.15987.95344.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 19:49 +0000, David Howells wrote:
> Disintegrate asm/system.h for PowerPC.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---

Not a bad idea :-) I'll run that through my compile tests.

Cheers,
Ben.


