Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1JQWAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:00:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55083 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1JQWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:00:31 -0400
Date: Mon, 17 Oct 2011 17:52:38 -0400 (EDT)
Message-Id: <20111017.175238.18474279385644215.davem@davemloft.net>
To: dpmcgee@gmail.com
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Disable TCP_DEBUG and FASTRETRANS_DEBUG by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318883125-29500-1-git-send-email-dpmcgee@gmail.com>
References: <1318883125-29500-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 17 Oct 2011 14:52:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan McGee <dpmcgee@gmail.com>
Date: Mon, 17 Oct 2011 15:25:24 -0500

> If these are truly debug options, they should be turned off by default
> and can be tweaked if necessary. Fix one usage of the flag to use #if
> instead of #ifdef so defining to zero is acceptable.
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>

Illegal window shrinks are a serious issue, and the fact that everyone
will see those messages by default and sometimes report them has been
tremendously useful.
