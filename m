Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2JPDnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 23:43:20 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55663 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2JPDnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 23:43:19 -0400
Date: Mon, 15 Oct 2012 23:43:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND] [PATCH 1/2] random: make it possible to enable
 debugging without rebuild
Message-ID: <20121016034315.GC17446@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LNX.2.00.1210081637170.28357@pobox.suse.cz>
 <alpine.LNX.2.00.1210152340390.14002@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210152340390.14002@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 11:42:55PM +0200, Jiri Kosina wrote:
> The module parameter that turns debugging mode (which basically means 
> printing a few extra lines during runtime) is in '#if 0' block. Forcing 
> everyone who would like to see how entropy is behaving on his system to 
> rebuild seems to be a little bit too harsh.
> 
> If we were concerned about speed, we could potentially turn 'debug' into a 
> static key, but I don't think it's necessary.
> 
> Drop the '#if 0' block to allow using the 'debug' parameter without rebuilding.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Applied to the random tree, thanks.

						- Ted
