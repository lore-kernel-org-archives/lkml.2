Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1J0JNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:13:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:33941 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab1J0JNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:13:35 -0400
Date: Thu, 27 Oct 2011 05:13:30 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fs: jdb/jbd2: Put identical code in a common header
Message-ID: <20111027091330.GA31921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <alpine.LFD.2.02.1110051328010.18778@ionos>
 <20111018204031.GE4599@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018204031.GE4599@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 10:40:31PM +0200, Jan Kara wrote:
> On Wed 05-10-11 13:29:29, Thomas Gleixner wrote:
> > The state bits and the lock functions of jbd and jbd2 are
> > identical. Share them.
>   Hum, Ted, I don't think this got picked up. What's your opinion?

It seems reasonable to me.  Factoring out common code is a good
though, although inline functions won't save any text space and since
this part of the jbd header files are rarely changed, so the
maintainability advantages are reduced.

I'll take the patch and include it in the ext4 tree.

     	      	    		   - Ted
