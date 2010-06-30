Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0F3OKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:10:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47153 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab0F3OKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ee8E7doWIR2oRBDvwln2lR8b8SLHWl0ZZTjjxddD7JJpXtx44Jv+9tt2b7gUBsh/Y/
         pgUDQaYOFM8oKe9fW3XtyH5CiDAtM9ys3DnZWfncO8rGdl627DDHsYsx3n/hSOEWz19X
         n1ElHaVGnee5IA+9XwsuybpONbh9uaWbF9fwU=
Date: Wed, 30 Jun 2010 23:10:03 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 06/11] oom: kill duplicate OOM_DISABLE check
Message-ID: <20100630141003.GD15644@barrios-desktop>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
 <20100630183019.AA59.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630183019.AA59.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:31:00PM +0900, KOSAKI Motohiro wrote:
> 
> select_bad_process() and badness() have the same OOM_DISABLE check.
> This patch kill one.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
