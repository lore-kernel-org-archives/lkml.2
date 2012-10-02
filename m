Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2JBGhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:37:42 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:39851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2JBGhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:37:41 -0400
Message-ID: <1349159890.10698.2.camel@jlt4.sipsolutions.net>
Subject: Re: How do I get mac80211 debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kevin Cruz <skate_ops@yahoo.com>
Cc: Intel Wireless <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 02 Oct 2012 08:38:10 +0200
In-Reply-To: <1349132818.58475.YahooMailNeo@web164006.mail.gq1.yahoo.com>
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>
	  <20120928121917.GF5368@mwanda>
	  <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	  <20120929072527.GA13767@mwanda>
	  <1349102641.41622.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	  <20121001150913.GC13767@mwanda>
	  <1349109750.55372.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	  (sfid-20121001_184314_573998_F50474BE) <1349119899.10330.53.camel@jlt4.sipsolutions.net>
	 <1349132818.58475.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> So I tried that but all I got back was:
> 
>     cat: /sys/kernel/debug/ieee80211/phy*/queues: No such file or directory
> 
> so I'm assuming it's because I must not have mac80211 debugfs.  So how
> do I get it?

First, make sure it's mounted, check "mount" and if not mount it:

sudo mount -t debugfs debugfs /sys/kernel/debug

If that doesn't work you don't have it enabled in the kernel config,
check for CONFIG_DEBUG_FS. If you do have it, but not mac80211's files,
check for CONFIG_MAC80211_DEBUGFS.

Thanks,
johannes

