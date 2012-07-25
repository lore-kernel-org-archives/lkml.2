Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344Ab2GYPQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:16:10 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:59598 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030229Ab2GYPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:16:07 -0400
Date: Wed, 25 Jul 2012 11:16:06 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <1933132989.2570662.1343229366388.JavaMail.root@redhat.com>
In-Reply-To: <1343229134-29487-16-git-send-email-artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH 15/16] gfs2: nuke pdflush from comments
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.3.112.29]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
| From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
| 
| The pdflush thread is long gone, so this patch removes references to
| pdflush
| from gfs comments.
| 
(snip)
| -		 * potentially cause a busy-wait loop from pdflush and kswapd
| +		 * potentially cause a busy-wait loop from flusher thread and

Hi,

ACK,

Just FYI: Steve Whitehouse is on holiday today.
You may want to send this patch to cluster-devel@redhat.com as well,
which is often where we send and review GFS2 patches.

Regards,

Bob Peterson
Red Hat File Systems
