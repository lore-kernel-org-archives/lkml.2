Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1BNPuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:50:39 -0500
Received: from stinky.trash.net ([213.144.137.162]:55499 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1BNPui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:50:38 -0500
Message-ID: <4D594F47.8070500@trash.net>
Date: Mon, 14 Feb 2011 16:50:31 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, security@kernel.org,
        Bart De Schuymer <bart.de.schuymer@pandora.be>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        ebtables-user@lists.sourceforge.net,
        ebtables-devel@lists.sourceforge.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] bridge: netfilter: fix information leak
References: <1297680875-11663-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1297680875-11663-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.02.2011 11:54, schrieb Vasiliy Kulikov:
> Struct tmp is copied from userspace.  It is not checked whether the "name"
> field is NULL terminated.  This may lead to buffer overflow and passing
> contents of kernel stack as a module name to try_then_request_module() and,
> consequently, to modprobe commandline.  It would be seen by all userspace
> processes.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks Vasiliy.
