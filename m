Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2ITVhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:37:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39627 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2ITVhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:37:22 -0400
Date: Thu, 20 Sep 2012 17:37:19 -0400 (EDT)
Message-Id: <20120920.173719.1238894522809866676.davem@davemloft.net>
To: chf.fritz@googlemail.com
Cc: rob@landley.net, kuznet@ms2.inr.ac.ru, j.weitzel@phytec.de,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, hjk@hansjkoch.de, daniel@zonque.org
Subject: Re: [PATCH] ipconfig: add nameserver IPs to kernel-parameter ip=
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348176485.3858.92.camel@mars>
References: <1348176485.3858.92.camel@mars>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Fritz <chf.fritz@googlemail.com>
Date: Thu, 20 Sep 2012 23:28:05 +0200

> +			pr_info("     nameserver%u=%pI4",
> +							i, &ic_nameservers[i]);

Why don't you just tab that second line out to planet Mars while
you're at it?

Please format this correctly, the goal is not to use a million
TAB characters.  Rather, the goal is to get the text starting
on the second line of a function call to line up with the
first column after the openning parenthesis on the previous line.

What you're doing there looks awful, so you'll need to fix this
up before this patch will be considered seriously.

Thanks.
