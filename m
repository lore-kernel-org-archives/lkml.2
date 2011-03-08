Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1CHTZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:25:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab1CHTZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:25:12 -0500
From: "Rafael J. Wysocki" <rjw@suse.com>
Organization: SUSE Labs
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
Date: Tue, 8 Mar 2011 20:25:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org> <4D75F34B.5010409@gmail.com>
In-Reply-To: <4D75F34B.5010409@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103082025.38559.rjw@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 08, 2011, Jiri Slaby wrote:
> On 02/22/2011 04:36 PM, Alan Stern wrote:
> > By the way, are you booting with no_console_suspend?  And do you do 
> > "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
> > suspending?
> 
> Unfortunately there are no messages at all.
> 
> Rafael, this is a Factory with intel gfx (modesetting). Do pm-utils
> switch a console in such case? And if yes, to which one?

pm-utils don't, but s2ram does, I'm not sure from the top of my head to
which one, though.

If you use a KMS driver (I get you do), please just "chmod a-x /usr/sbin/s2ram".

Thanks,
Rafael
