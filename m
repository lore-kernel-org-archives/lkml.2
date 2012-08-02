Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2HBMC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:02:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57634 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2HBMC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:02:27 -0400
Date: Thu, 2 Aug 2012 13:06:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz> (maintainer:EXT2 FILE SYSTEM),
        Rob Landley <rob@landley.net> (maintainer:DOCUMENTATION),
        Andrew Morton <akpm@linux-foundation.org> (maintainer:EXT3 FILE
	SYSTEM),
        Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT3 FILE
	SYSTEM),
        "Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM),
        linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: Re: [PATCH 1/3] implement uid and gid mount options for ext2
Message-ID: <20120802130642.46b12c59@pyramind.ukuu.org.uk>
In-Reply-To: <1343908443-17369-2-git-send-email-ludwig.nussel@suse.de>
References: <1343908443-17369-1-git-send-email-ludwig.nussel@suse.de>
	<1343908443-17369-2-git-send-email-ludwig.nussel@suse.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +uid=n[:m]			Make all files appear to belong to uid n.
> +				Useful for e.g. removable media with fstab
> +				options 'user,uid=useruid'. The optional second
> +				uid m is actually written to the file system.

So what happens if I insert a USB key containing a device node to the
hard disk ? Why is this functionality useful in the current form ?

(ie I think you need an actual rational security model first)


Also why is this at the per fs level duplicating stuff each time rather
than at the vfs level - this seems to be vfs level functionality.

> +
> +gid=n[:m]			Make all files appear to belong to gid n.
> +				The optional second gid m is actually written to
> +				the file system.

Your documentation seems only half completed ?

Alan
