Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1EXGVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:21:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59151 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1EXGVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:21:52 -0400
Date: Tue, 24 May 2011 02:21:44 -0400 (EDT)
Message-Id: <20110524.022144.2121988243667976554.davem@davemloft.net>
To: justinmattock@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        greearb@candelatech.com
Subject: Re: [PATCH v2]net:8021q:vlan.c Fix pr_info to just give the vlan
 fullname and version.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306215647-2857-1-git-send-email-justinmattock@gmail.com>
References: <1306215647-2857-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 May 2011 23:21:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>
Date: Mon, 23 May 2011 22:40:47 -0700

> The below patch removes vlan_buggyright and vlan_copyright from vlan_proto_init, 
> so that it prints out just the fullname of vlan and the version number.

Come on Justin, you're making various strings now completely
unreferenced.  Don't just leave them there, remove them.
