Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1JRSmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:42:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:21737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab1JRSmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="64438275"
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: werner <w.landgraf@ru.ru>, David Rientjes <rientjes@google.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201110181957.49894.toralf.foerster@gmx.de>
References: <201110152119.58509.toralf.foerster@gmx.de>
	 <201110181847.02971.toralf.foerster@gmx.de>
	 <1318958013.25023.16.camel@wwguy-ubuntu>
	 <201110181957.49894.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 10:51:43 -0700
Message-ID: <1318960303.31823.34.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 10:57 -0700, Toralf Förster wrote:
> wwguy wrote at 19:13:33
> > hmm, something broken there, it should be in the .config file, what tree
> > you are using?
> > 
> tfoerste@n22 ~/devel/linux $ git describe
> v3.1-rc10
> tfoerste@n22 ~/devel/linux $ grep -B2 url .git/config 
> [remote "origin"]
>         fetch = +refs/heads/*:refs/remotes/origin/*
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> --
>         merge = refs/heads/master
> [remote "remote_stable"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable.git
> 
> 
> 
you did not enable MAC80211_DEBUGFS

Wey

