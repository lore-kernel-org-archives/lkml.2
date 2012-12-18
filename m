Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2LRCHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:07:34 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:49021 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab2LRCHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:07:33 -0500
Date: Tue, 18 Dec 2012 02:07:32 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andreas Voellmy <andreas.voellmy@yale.edu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "junchang.wang@yale.edu Wang" <junchang.wang@yale.edu>
Subject: Re: epoll with ONESHOT possibly fails to deliver events
Message-ID: <20121218020732.GA13396@dcvr.yhbt.net>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu>
 <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu>
 <20121213093242.GA25436@dcvr.yhbt.net>
 <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu>
 <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu>
 <4F40C83D-1C29-4654-8B9C-9DBFB63BDC1D@yale.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F40C83D-1C29-4654-8B9C-9DBFB63BDC1D@yale.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
> There were a couple of errors in the code when I posted my last
> message. I have fixed those. The epoll bug still occurs. 

Sorry I haven't gotten around to this.

Can you reproduce this with fewer cores? (I only have 4 at most).
Have you tried the latest stable kernel version?

Can you reproduce this over TCP loopback, or only across two machines?
If the latter, it could also be a driver or firmware bug...
