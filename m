Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0KFMuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 08:50:44 -0400
Received: from THUNK.ORG ([69.25.196.29]:38819 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0KFMun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 08:50:43 -0400
Date: Sat, 6 Nov 2010 08:50:36 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Tony Vroon <tony@linx.net>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: BUG in ext4 with 2.6.37-rc1
Message-ID: <20101106125036.GL7553@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Tony Vroon <tony@linx.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20101102202013.GA3861@elliptictech.com>
 <1288998589.2961.3.camel@localhost>
 <0C557864-9D5C-45A3-8DDF-114E4DD22258@mit.edu>
 <1289003976.2961.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289003976.2961.10.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 12:39:36AM +0000, Tony Vroon wrote:
> Unlike Nick however, I do not have a specific "this does it 100% of the
> time" command. At least, I updated CVS again after it died roughly 90%
> in; after deleting the directories CVS was unhappy with the sync
> completed.
> Syncing CVS too often would be a bit unfair on the server at the other
> end, so I will try this again tomorrow.

Fair enough.  I may try to build gcc and use that as a repro case.  My
attempts to build quick synthetic repro's haven't been successful to
date.

						- Ted
