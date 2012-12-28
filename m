Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2L1HGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 02:06:55 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:52762 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab2L1HGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 02:06:52 -0500
Date: Fri, 28 Dec 2012 07:06:52 +0000
From: Eric Wong <normalperson@yhbt.net>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andreas Voellmy <andreas.voellmy@yale.edu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "Junchang(Jason) Wang" <junchang.wang@yale.edu>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20121228070652.GA6292@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228014503.GA5017@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> I'm finding ppoll() unexpectedly stuck when waiting for POLLIN on a
> local TCP socket.  The isolated code below can reproduces the issue
> after many minutes (<1 hour).  It might be easier to reproduce on
> a busy system while disk I/O is happening.

Ugh, I can't seem to reproduce this anymore...  Will try something
else tomorrow.
