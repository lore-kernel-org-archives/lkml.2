Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190Ab2HLEFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:05:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57758 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2HLEFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:05:40 -0400
Date: Sat, 11 Aug 2012 21:05:40 -0700 (PDT)
Message-Id: <20120811.210540.1158066885515664193.davem@davemloft.net>
To: yamato@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] net: proc entry showing inodes on sockfs and
 their types
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I also want to mention that I absolutely do not consider better lsof
support important at all.

So if you want to add this, it had to be exactly zero overhead and it
must not break anything that exists already.  Your patch set violates
this on both counts.
