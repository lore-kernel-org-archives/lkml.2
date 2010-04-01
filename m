Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0DARaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:30:16 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:64348 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755148Ab0DARaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:30:08 -0400
Message-ID: <4BB4D817.1050603@users.sourceforge.net>
Date: Thu, 01 Apr 2010 19:29:59 +0200
From: =?ISO-8859-1?Q?Anders_Grafstr=F6m?= <grfstrm@users.sourceforge.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       AKML <linux-arm-kernel@lists.infradead.org>,
       linux-wireless@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Sven Neumann <s.neumann@raumfeld.com>, stable@kernel.org
Subject: Re: Memory corruption with 2.6.32.10, but not with 2.6.34-rc3
References: <20100401132156.GJ30807@buzzloop.caiaq.de>
In-Reply-To: <20100401132156.GJ30807@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> We would like to have a fix for this annoying bug in the stable series
> (especially 2.6.32.x) as well, but I don't have much ideas about where
> to search for it. Hence, I would appreciate if maintainers could think
> about any possible commits in the described time window which haven't
> reached stable. Does the description ring anyone's bell?
> 
> I can cherry-pick things if anyone pin-points something and run
> lont-time tests again. Any pointer appreciated.

You could try this one:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8e4971f2fb2380ce66196136e113d04196b80fcd

