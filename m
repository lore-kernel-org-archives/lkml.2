Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0IGKeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:34:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46201 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab0IGKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=a1Bpvik8M+XrTbMNJpGXAQb5gsBhV9TIIw+4cjLTcgxIjN4fRNhDmWJ1eOstklUrK2
         IQAZKj+4T3XB3ef/0PypzS4T7OyyUHKy7YL088AFWVUFNhNQfuO0nUVD0zZPwgHR2G4u
         HFlbvt2XnEUaScB1Z+D2a4wSdfJYD27o22FyM=
Date: Tue, 7 Sep 2010 10:34:13 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PROBLEM] ipw2200: WARNING: at kernel/softirq.c:143
	local_bh_enable+0x58/0x80()
Message-ID: <20100907103412.GA8999@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=BBQL5cS6Ox8MGiy+Pun56xtEhakJxeLwx9UnW@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-05 17:11, Pekka Enberg wrote:
> Hi,
> 
> This showed up in dmesg:
> 
> [  143.695527] ------------[ cut here ]------------
> [  143.695550] WARNING: at kernel/softirq.c:143 local_bh_enable+0x58/0x80()
> [  143.695557] Hardware name: 2373KYG
> [  143.695562] Modules linked in: ipw2200 libipw
> [  143.695577] Pid: 4112, comm: NetworkManager Not tainted 2.6.36-rc2+ #182
> [  143.695584] Call Trace:
> [  143.695596]  [<c15b8ddc>] ? printk+0x18/0x1a
> [  143.695610]  [<c1033fbd>] warn_slowpath_common+0x6d/0xa0
> [  143.695620]  [<c1039568>] ? local_bh_enable+0x58/0x80
> [  143.695630]  [<c1039568>] ? local_bh_enable+0x58/0x80
> [  143.695640]  [<c103400b>] warn_slowpath_null+0x1b/0x20
> [  143.695650]  [<c1039568>] local_bh_enable+0x58/0x80
> [  143.695662]  [<c1482d25>] netif_rx+0x155/0x180
> [  143.695677]  [<f807519c>] libipw_rx+0x55c/0xad0 [libipw]
> [  143.695703]  [<f816f86a>] ipw_handle_data_packet+0x12a/0x260 [ipw2200]

Hi,
Here is the thread:

http://www.spinics.net/lists/netdev/msg139731.html

Jarek P.
