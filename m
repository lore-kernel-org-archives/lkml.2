Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0F3Oa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:30:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57216 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab0F3OaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TxBUaD35ABI/zS2qQxSx7rtjsNRi1faeH7xGCFqe39lfdsVnVzXgaGtb3UPiRJFeGc
         SjhEi5t0oqc4cHjoir3vJj21fh1Emnf7cByWa7QSxPV0ECc5pHqaqum6KwGi3+A+Kbk7
         7ZljOug93rdoDsU0go7a02qBxJL2/pu+xCZM0=
Date: Wed, 30 Jun 2010 23:30:13 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 09/11] oom: remove child->mm check from
 oom_kill_process()
Message-ID: <20100630143013.GG15644@barrios-desktop>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
 <20100630183209.AA62.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630183209.AA62.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:32:44PM +0900, KOSAKI Motohiro wrote:
> 
> Current "child->mm == p->mm" mean prevent to select vfork() task.
> But we don't have any reason to don't consider vfork().

I guess "child->mm == p->mm" is for losing the minimal amount of work done
as comment say. But frankly speaking, I don't understand it, either.
Maybe "One shot, two kill" problem?

Andrea. Could you explain it?

-- 
Kind regards,
Minchan Kim
