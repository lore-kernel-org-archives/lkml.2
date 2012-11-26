Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2KZOoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:44:01 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:34847 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab2KZOoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:44:00 -0500
Date: Mon, 26 Nov 2012 09:43:54 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121126144354.GI31891@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126002814.GM32450@dastard>
 <20121126025520.GC22858@thunk.org>
 <20121126115345.19977e46@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126115345.19977e46@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:53:45AM +0000, Alan Cox wrote:
> > It's not like there is any shortage of flag bits, so what's the harm
> > of reserving the bit?
> 
> Why not just reserve a small group of bits for fs private use in that
> case - for any fs.

I think that would be a *fine* idea.

						- Ted
