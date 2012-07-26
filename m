Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2GZJLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab2GZJLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:11:43 -0400
Subject: Re: [PATCH 15/16] gfs2: nuke pdflush from comments
From: Steven Whitehouse <swhiteho@redhat.com>
To: Bob Peterson <rpeterso@redhat.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1933132989.2570662.1343229366388.JavaMail.root@redhat.com>
References: <1933132989.2570662.1343229366388.JavaMail.root@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 26 Jul 2012 10:10:12 +0100
Message-ID: <1343293812.2720.10.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2012-07-25 at 11:16 -0400, Bob Peterson wrote:
> ----- Original Message -----
> | From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> | 
> | The pdflush thread is long gone, so this patch removes references to
> | pdflush
> | from gfs comments.
> | 
> (snip)
> | -		 * potentially cause a busy-wait loop from pdflush and kswapd
> | +		 * potentially cause a busy-wait loop from flusher thread and
> 
> Hi,
> 
> ACK,
> 
> Just FYI: Steve Whitehouse is on holiday today.
> You may want to send this patch to cluster-devel@redhat.com as well,
> which is often where we send and review GFS2 patches.
> 
> Regards,
> 
> Bob Peterson
> Red Hat File Systems

That ok, I spotted it anyway and it is fairly minor as patches go.
Artem, do you want to keep this patch in your series or should I queue
it up for the GFS2 tree? I don't mind which and it has my ack anyway,

Steve.


