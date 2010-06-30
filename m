Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0F3ODJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:03:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38335 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab0F3ODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QHxKgxfBTaMQDxQ9N5gejgYNRQtXhHhVppKaweQjq2BH1T4tVnVhjCX3BZQ3ronsLh
         C1CCZGskumhB9n/dDnXWRdFR5SEr9OTxCuB/h3Wr3tJMHERgcpWOhxNcHsxc3Kj9REzy
         MC1bgRNI5gp/NoqJxaIHEqzwpCtHwA9wietRE=
Date: Wed, 30 Jun 2010 22:57:31 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 04/11] oom: oom_kill_process() need to check p is
 unkillable
Message-ID: <20100630135731.GB15644@barrios-desktop>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
 <20100630182838.AA53.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630182838.AA53.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:29:22PM +0900, KOSAKI Motohiro wrote:
> When oom_kill_allocating_task is enabled, an argument task of
> oom_kill_process is not selected by select_bad_process(), It's
> just out_of_memory() caller task. It mean the task can be
> unkillable. check it first.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kind regards,
Minchan Kim
