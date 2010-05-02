Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab0EBV4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 17:56:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56153 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756181Ab0EBV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 17:56:22 -0400
Date: Sun, 2 May 2010 17:56:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend
 blockers from user-space
In-Reply-To: <201005022323.30128.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1005021755320.30701-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 May 2010, Rafael J. Wysocki wrote:

> Hmm.  It doesn't seem to be possible to create two different suspend blockers
> using the same file handle.  So, what exactly is a process supposed to do to
> use two suspend blockers at the same time?

Open the file twice, thereby obtaining two file handles.

Alan Stern

