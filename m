Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0F3OYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:24:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48517 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0F3OYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OQ7HSAnBUNASN38Bx0cdgUqlPYsH2jRaXwxKnxHcmLTBITAlNEfb2BaQpHdNs7Xrwt
         olKrOwRQg/sBuhpTSIo9h1CT424n4wJMtil7KETCtH0+KTcMQny4kCI4xZ5h9uic3/1y
         L2hQ/SeRCcs5ThPcb8+rl6I9QBD2ftO5ABtfk=
Date: Wed, 30 Jun 2010 22:55:03 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 02/11] oom: oom_kill_process() doesn't select kthread
 child
Message-ID: <20100630135503.GA15644@barrios-desktop>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
 <20100630182715.AA4B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630182715.AA4B.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:27:52PM +0900, KOSAKI Motohiro wrote:
> Now, select_bad_process() have PF_KTHREAD check, but oom_kill_process
> doesn't. It mean oom_kill_process() may choose wrong task, especially,
> when the child are using use_mm().

Is it possible child is kthread even though parent isn't kthread?

-- 
Kind regards,
Minchan Kim
