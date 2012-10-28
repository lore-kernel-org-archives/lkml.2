Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2J1WvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 18:51:13 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58171 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2J1WvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 18:51:12 -0400
Date: Sun, 28 Oct 2012 18:51:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.6.0 ext4 dump/filemap_fault?
Message-ID: <20121028225109.GA6931@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org
References: <015201cdb54f$844487e0$8ccd97a0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <015201cdb54f$844487e0$8ccd97a0$@lucidpixels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 05:02:17PM -0400, Justin Piszcz wrote:
> Hello,
> 
> Any idea what happened here (during a backup)?

A sync system call took longer than two mintues.  Why that happened,
it's harder to say.  It's a warning, though, and not a fatal panic or
kernel oops.

How much memory do you have in your system?  What happened afterwards?
Did the system continue, and did the sync command (I presume you ran
"sync" from the command line?)  finally return to the command prompt?

    	    	 	 	 	   - Ted
