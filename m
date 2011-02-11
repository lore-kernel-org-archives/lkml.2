Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1BKOwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:52:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:56329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab1BKOwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:52:38 -0500
Date: Fri, 11 Feb 2011 06:53:16 -0800
From: Greg KH <gregkh@suse.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@woodhou.se" <david@woodhou.se>,
        "Woodhouse, David" <david.woodhouse@intel.com>
Subject: Re: [RFC PATCH 01/13] Intel(R) MEI Driver
Message-ID: <20110211145316.GA13146@suse.de>
References: <b9dded$htd8nk@orsmga002.jf.intel.com>
 <20110210180044.GD13795@suse.de>
 <F28B59AD52D84B479DCA46982447533506505D9ACE@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F28B59AD52D84B479DCA46982447533506505D9ACE@hasmsx503.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:57:31AM +0200, Weil, Oren jer wrote:
> Hi
> 
> 1) For the review purpose we wanted to split the patches into files, so the
> only way we found to do it is using "git diff", this is they there is not
> signed-off-by line
> Maybe I should have adding a description for every file, I can send another
> mail with the descriptions, sorry for the mess.

Again, please read the documentation on how to properly send patches.
We write it for a reason, not to just be ignored.

Actually, if you do ignore it, it's easy for us to ignore you, and
somehow I doubt you want that.

> 2) "Intel(R) Management Engine Interface (Intel(R) MEI)" - is our official
> name.

That's nice, but it's not anything that kernel developers want to see
all the time.  Drop the (R) please, it's pointless within the kernel
sources.

> 3) we ran checkpatch.pl on every file, this file my by skipped by mistake.

It wasn't the only file you skipped, I saw lots of coding style
violations in the other files, so I really don't believe you.

good luck,

greg k-h
