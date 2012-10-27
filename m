Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966923Ab2J0AHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 20:07:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57894 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966897Ab2J0AHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 20:07:44 -0400
Date: Fri, 26 Oct 2012 20:07:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Martin <marogge@onlinehome.de>, linux-ext4@vger.kernel.org,
        Nix <nix@esperi.org.uk>
Subject: Re: ext4 issue after unclean shutdown and reboot
Message-ID: <20121027000736.GA31030@thunk.org>
References: <508B199E.6020107@onlinehome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508B199E.6020107@onlinehome.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've bcc'ed stable@vger.kernel.org, LKML, and greg-kh, since I suspect
they aren't interested in all of these details... we'll keep this on
linux-ext4 for sanity's sake.

On Sat, Oct 27, 2012 at 01:15:42AM +0200, Martin wrote:
> 
> sorry for the repetition, but Theodore Ts'o asked me to re-post this
> as a new mail thread in order to keep track of this more easily.

1)  Is it repeatable?  This is what happened once.  Can you reliably reproduce it?

2)  Can you send the full dmesg of the previous boot and the boot where
you found the problem?

3)  Can you send me the fsck logs?

4)  Can you send me the output dumpe2fs on the file system in question?

Thanks....

						- Ted
