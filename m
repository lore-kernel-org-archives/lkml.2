Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0HSP3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:29:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56538 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab0HSP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SLrREkdfzsJgVb2z+BUlHknQmmUaCfrJ4AB+8RAB9c2/tTNH8Co0XRtTOQw6QLQxAx
         Ed22sFqF7ZzwJmLVTB3DDGn26yDaXG+ukalkmpZkaoyltytcFJRERTindG+nELoXWL35
         Coh58fGpk9B0lxxtJrVbn1d52koZ0yKG9qrGY=
Date: Fri, 20 Aug 2010 00:29:37 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] oom: fix NULL pointer dereference
Message-ID: <20100819152937.GE6805@barrios-desktop>
References: <20100819194707.5FC4.A69D9226@jp.fujitsu.com>
 <20100819195310.5FC7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819195310.5FC7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 07:53:31PM +0900, KOSAKI Motohiro wrote:
> commit b940fd7035 (oom: remove unnecessary code and cleanup) added
> unnecessary NULL pointer dereference. remove it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
