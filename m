Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2BHX3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:29:53 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49201 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2BHX3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:29:52 -0500
Date: Wed, 08 Feb 2012 18:29:42 -0500 (EST)
Message-Id: <20120208.182942.1223790992368933837.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/50] set addr_assign_type to NET_ADDR_RANDOM if
 a random mac address get assigned to a netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 15:29:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


50 patches is way too many patches to submit and expect people
to review at one time.

You must do one of two things:

1) Condense the series down to a smaller number of more managable
   patches.  Perhaps combine all the completely trivial conversion
   cases into one single patch, and post the non-trivial cases
   seperately.

2) Only submit a few of these changes at a time, not all at once.

It's your choice, but what you did here is unacceptable.
