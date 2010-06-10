Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0FJUXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:23:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0FJUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:23:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=fVy+L8fovY0HLTXLCZ8WHzccEAJea8WJg1DKqzS7rVl2MjU5r04QaZ1LBPfyPvJSc
	iqVDPsXJGqqhqsT31uMfA==
Date: Thu, 10 Jun 2010 13:23:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Cleanup : change try_set_zone_oom with
 try_set_zonelist_oom
In-Reply-To: <1276177124-3395-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <alpine.DEB.2.00.1006101322460.20197@chino.kir.corp.google.com>
References: <1276177124-3395-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Minchan Kim wrote:

> We have been used naming try_set_zone_oom and clear_zonelist_oom.
> The role of functions is to lock of zonelist for preventing parallel
> OOM. So clear_zonelist_oom makes sense but try_set_zone_oome is rather
> awkward and unmatched with clear_zonelist_oom.
> 
> Let's change it with try_set_zonelist_oom.
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Let's change it with try_set_zonelist_oom.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
