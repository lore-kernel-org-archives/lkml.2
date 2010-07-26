Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0GZFlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:41:19 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46606 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab0GZFlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:41:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoHAE69TEx5LclT/2dsb2JhbACTGYxGcr8lhTYE
Date: Mon, 26 Jul 2010 15:41:11 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: VFS scalability git tree
Message-ID: <20100726054111.GA2963@amd>
References: <20100722190100.GA22269@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722190100.GA22269@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 05:01:00AM +1000, Nick Piggin wrote:
> I'm pleased to announce I have a git tree up of my vfs scalability work.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git

Pushed several fixes and improvements
o XFS bugs fixed by Dave
o dentry and inode stats bugs noticed by Dave
o vmscan shrinker bugs fixed by KOSAKI san
o compile bugs noticed by John
o a few attempts to improve powerpc performance (eg. reducing smp_rmb())
o scalability improvments for rename_lock


