Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab2EIITw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:19:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41158 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2EIITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:19:49 -0400
Date: Wed, 9 May 2012 03:19:39 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Marc MERLIN <marc@merlins.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 075/167] [PATCH 15/26] tcp: avoid order-1 allocations on wifi
 and tx path
Message-ID: <20120509081939.GE32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055040.232524491@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055040.232524491@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> 3.2-stable review patch.
[...]
> [ This combines upstream commit
>   a21d45726acacc963d8baddf74607d9b74e2b723 and the follow-on bug fix
>   commit 22b4a4f22da4b39c6f7f679fd35f3d35c91bf851 ]

If patch 074 ("tcp: fix tcp_trim_head()") were dropped, then the
follow-on bug fix 22b4a4f22da4 presumably would not be needed any
more.  (Commit a21d45726aca applies cleanly on top of 3.2.y, but I
haven't tested the result.)
