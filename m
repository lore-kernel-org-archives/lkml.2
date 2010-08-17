Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0HQOnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:43:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60802 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab0HQOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WmQxTH2OAPA+tArge5sZXIs2IbNjThUNmDWsu/MKhX4ZjXcRUyTXli4FezamkqBKqd
         WWh4YPOGMpuiyjoOPB5mdRaqcybfv+olidEqCp2pgI9dyx3dBvbCTti/UL/Ga/sYOtRu
         6Iat1QYuYL7D3ZbPrzV3ugFzOcG1dSrnPtqIw=
Date: Tue, 17 Aug 2010 23:42:56 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Export mlock information via smaps
Message-ID: <20100817144256.GC3884@barrios-desktop>
References: <201008171039.31070.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008171039.31070.knikanth@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:39:31AM +0530, Nikanth Karthikesan wrote:
> Currently there is no way to find whether a process has locked its pages in
> memory or not. And which of the memory regions are locked in memory.
> 
> Add a new field to perms field 'l' to export this information. The information
> exported via maps file is not changed.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Cced Matt. 

It would be good if we have a such thing. 
In addtion, code itself looks good to me. :)

But I have a question. 
Why didn't you change /proc/map? 
Due to ABI? So then, Is it okay to change smaps ABI?

I don't know there is any well-known tool to use smap information. 
Maybe Matt have the answer. 


-- 
Kind regards,
Minchan Kim
