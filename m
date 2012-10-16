Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2JPDnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 23:43:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55667 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab2JPDnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 23:43:33 -0400
Date: Mon, 15 Oct 2012 23:43:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND] [PATCH 2/2] random: fix debug format strings
Message-ID: <20121016034331.GD17446@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LNX.2.00.1210081637170.28357@pobox.suse.cz>
 <alpine.LNX.2.00.1210081639340.28357@pobox.suse.cz>
 <alpine.LNX.2.00.1210152343050.14002@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210152343050.14002@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 11:43:29PM +0200, Jiri Kosina wrote:
> Fix the following warnings in formatting debug output:
> 
> drivers/char/random.c: In function ‘xfer_secondary_pool’:
> drivers/char/random.c:827: warning: format ‘%d’ expects type ‘int’, but argument 7 has type ‘size_t’
> drivers/char/random.c: In function ‘account’:
> drivers/char/random.c:859: warning: format ‘%d’ expects type ‘int’, but argument 5 has type ‘size_t’
> drivers/char/random.c:881: warning: format ‘%d’ expects type ‘int’, but argument 5 has type ‘size_t’
> drivers/char/random.c: In function ‘random_read’:
> drivers/char/random.c:1141: warning: format ‘%d’ expects type ‘int’, but argument 5 has type ‘ssize_t’
> drivers/char/random.c:1145: warning: format ‘%d’ expects type ‘int’, but argument 5 has type ‘ssize_t’
> drivers/char/random.c:1145: warning: format ‘%d’ expects type ‘int’, but argument 6 has type ‘long unsigned int’
> 
> by using '%zd' instead of '%d' to properly denote ssize_t/size_t conversion.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Applied to the random tree, thanks.

						- Ted
