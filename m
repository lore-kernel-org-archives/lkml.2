Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0H2Pkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:40:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53142 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab0H2Pks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CP2CCdqGvfjFwzDgaaZ78IEF5wM4UlwjG+j9QezYpMERZV4h88T3e/pJTVVWzD9dJo
         3OHchJkBn3bCN7hTTttBqEI9bEE/46PAZcJNXE6UJqLKplwvpsmUPtWIgTt3uBM8si1L
         64fT0xtoF5ET3w/BxmRF8QygUk4CR0kdmvywk=
Date: Mon, 30 Aug 2010 00:40:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: fix missing place to check nr_swap_pages.
Message-ID: <20100829154040.GA2714@barrios-desktop>
References: <1282867897-31201-1-git-send-email-yinghan@google.com>
 <AANLkTimaLBJa9hmufqQy3jk7GD-mJDbg=Dqkaja0nOMk@mail.gmail.com>
 <AANLkTi=xUMSZ7wX-2BtJ0-+2BYLCTW=VPTAErinb5Zd2@mail.gmail.com>
 <AANLkTinP_q7S4_O921hdBoedmTp-7gw0+=4DPHZGmysi@mail.gmail.com>
 <AANLkTin6+nHOowdptW2jaxg9urn3OLf9ArgGzKjWnQLM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin6+nHOowdptW2jaxg9urn3OLf9ArgGzKjWnQLM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 09:35:58AM -0700, Ying Han wrote:
 
> Also, we found it is quite often to hit the condition
> inactive_anon_is_low on machine with small numa node size, since the
> zone->inactive_ratio is set based on the zone->present_pages.

What's your memory configuration and memory size?

Now we have zoned page allocator and zoned page reclaimer. 
So it makes sense to me. :)

Anyway, I will resend new version. Thanks, Ying. 
-- 
Kind regards,
Minchan Kim
