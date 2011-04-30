Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab1D3QqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 12:46:21 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:52249 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756423Ab1D3QqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 12:46:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WUf8t1RD7bRHxR+fJZfrp9nb3BuoJr9BbJMMrumVy7vLwm4JRPin2Jt6wQw8kffqC+OVx3uPJvdd8b7bCedsYvi+lrOzUssNT270WRLwwcVF7R4zkUpN29I9NMzO5i/c;
Date: Sat, 30 Apr 2011 09:46:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-04-29-16-25 uploaded
Message-Id: <20110430094616.1fd43735.rdunlap@xenotime.net>
In-Reply-To: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org>
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 16:26:16 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-04-29-16-25 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.39-rc5:


mm-per-node-vmstat-show-proper-vmstats.patch

when CONFIG_PROC_FS is not enabled:

drivers/built-in.o: In function `node_read_vmstat':
node.c:(.text+0x1e995): undefined reference to `vmstat_text'

from drivers/base/node.c

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
