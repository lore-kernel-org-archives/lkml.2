Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1JABPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 21:15:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58244 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1JABP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 21:15:26 -0400
Date: Fri, 30 Sep 2011 21:15:20 -0400 (EDT)
Message-Id: <20110930.211520.1376313955703692517.davem@davemloft.net>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110930235924.GA25176@kroah.com>
References: <4E8655CD.90107@zytor.com>
	<20110930235924.GA25176@kroah.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 30 Sep 2011 18:15:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Fri, 30 Sep 2011 16:59:24 -0700

> 1. Install the chkrootkit package from your distro repository and see if it
>    reports anything.  If your distro doesn't have the chkroot package,
>    download it from:
> 	http://www.chkrootkit.org/
> 
>    Another tool is the ossec-rootcheck tool which can be found at:
> 	http://www.ossec.net/main/rootcheck
> 
>    And another one is the rkhunter program:
>    	http://www.rootkit.nl/projects/rootkit_hunter.html
>    [Note, this tool has the tendancy to give false-positives on some
>    Debian boxes, please read /usr/share/doc/rkhunter/README.Debian.gz if
>    you run this on a Debian machine]

I quickly found that it gives false positives on Fedora15 too.

It thinks one is infected with Suckit.

It's check is essentially "strings /sbin/init | egrep HOME" which
triggers with:

	XDG_CONFIG_HOME
	XDG_DATA_HOME
	HOME=%s

I'm sure chkrootkit might be useful as a guide, but the seeming
pervasiveness of it's false positives make it much less useful than it
could be.
