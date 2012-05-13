Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab2EMEYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 00:24:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:34393 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2EMEYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 00:24:42 -0400
Date: Sun, 13 May 2012 00:24:35 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: Ludwig Nussel <ludwig.nussel@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Message-ID: <20120513042435.GB31866@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Rob Landley <rob@landley.net>,
	Ludwig Nussel <ludwig.nussel@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
 <20120511034945.GA15892@mobil.systemanalysen.net>
 <4FAD2161.3090108@landley.net>
 <20120511164605.GC6467@thunk.org>
 <4FADB860.2000009@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FADB860.2000009@landley.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 08:09:52PM -0500, Rob Landley wrote:
> However, 95% of this use case is already covered by FAT, considering
> that most of these people are going to want to interchange with windows
> and mac, neither of which are necessarily happy with an ext3 formatted
> USB stick. (Sadly, that's what I normally do.  My usb keychain is fat
> formatted, because otherwise I can't use it to give a PDF to the guy at
> kinko's to print out. I suspect this is why it hasn't previously come up
> much.)

The other reason why I suspect it hasn't come up often is that USB
sticks are so painfully slow that the file system really isn't a
bottleneck.

I would expct this might be different if you were using a removable
HDD (or even an SSD) with a USB 3.0 interface.  In that case you
really might want a bette file system than VFAT, especially if you are
interchanging with another Linux system with an incompatible uid/gid
namespace.  That's not nearly as common a use case, though.

	    	       	      	 	      - Ted
