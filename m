Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2JSVH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:07:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56355 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab2JSVH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:07:28 -0400
Date: Fri, 19 Oct 2012 17:07:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error w/ external USB drive
Message-ID: <20121019210723.GA4721@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <507C4BDA.20205@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <507C4BDA.20205@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 07:46:02PM +0200, Toralf Förster wrote:
> Even with current stable kernel 3.6.2 I sometimes get those syslog messages :
> 
> 
> 2012-10-15T19:37:58.401+02:00 n22 kernel: EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 436, 22902 clusters in bitmap, 22901 in gd

Have you run e2fsck to clean up the file system corruption?  If you
have, do you continually get these errors afterwards?

You say this is an external USB disk; is there any possibility of the
disk getting unmounted uncleanly due to the cable getting pulled out
while the disk is still mounted, and then the disk getting remounted
w/o having e2fsck run on the disk?

					- Ted
