Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1LFVIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:08:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48575 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1LFVIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:08:42 -0500
Date: Tue, 6 Dec 2011 13:08:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Shi <alex.shi@intel.com>
cc: cl@linux.com, penberg@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/3] slub: remove unnecessary statistics,
 deactivate_to_head/tail
In-Reply-To: <1322814189-17318-2-git-send-email-alex.shi@intel.com>
Message-ID: <alpine.DEB.2.00.1112061306510.28251@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <1322814189-17318-2-git-send-email-alex.shi@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Alex Shi wrote:

> From: Alex Shi <alexs@intel.com>
> 
> Since the head or tail were automaticly decided in add_partial(),
> we didn't need this statistics again.
> 

Umm, we shouldn't need to remove these statistics at all: if there is 
logic in add_partial() to determine whether to add it to the head or tail, 
the stats can still be incremented there appropriately.  It would actually 
be helpful to cite those stats for your netperf benchmarking when 
determining whether patches should be merged or not.
