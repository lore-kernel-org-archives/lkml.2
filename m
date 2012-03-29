Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2C2S3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759686Ab2C2S3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:29:23 -0400
Date: Thu, 29 Mar 2012 14:29:19 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329182919.GB6891@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Theodore Ts'o <tytso@mit.edu>
References: <20120329155542.GA31285@redhat.com>
 <CA+55aFySh2VJ3+Hdu8oFR3oBERS0uh=3ezBsbkWQNfsLHSDyqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFySh2VJ3+Hdu8oFR3oBERS0uh=3ezBsbkWQNfsLHSDyqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 11:23:57AM -0700, Linus Torvalds wrote:

 > That's doubly true since I see processes waiting for the journal lock,
 > but I don't actually see anything waiting for journal IO completion.
 > Did something not release the journal lock. Even banshee - that *is*
 > waiting for actual IO - seems to wait for page_writeback, which is not
 > done by the *disk* driver, but by the filesystem (end_page_writeback).
 > So that would be consistent with the ext4 changes having broken that.
 > 
 > Was there a previous post-3.3 git kernel that worked?

This is the first one I tried. (I've not been anywhere with the laptop
since 3.3 -- clearly I need to get out more). 

3.3 final worked ok though.

	Dave

