Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2GSUhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:37:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50689 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2GSUhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:37:50 -0400
Date: Thu, 19 Jul 2012 15:37:43 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/34] mm: vmscan: Do not force kswapd to scan small
 targets
Message-ID: <20120719203743.GD19392@burratino>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-31-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342708604-26540-31-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> commit ad2b8e601099a23dffffb53f91c18d874fe98854 upstream - WARNING: partial backport only
>
> Stable note: Not tracked in Bugzilla. This patch is very controversial for
> 	-stable. The upstream patch is addressing a completely different
> 	issue but accidentally contained an important fix. The workload
> 	in question was running memcached and then started IO in the
> 	background. memcached should stay resident but without this patch
> 	it gets swapped. Sometimes this manifests as a drop in throughput
> 	but mostly it was observed through /proc/vmstat.

I had thought partial backports like this were pretty normal and ok,
actually, as long as they are well explained.  Otherwise there would
be no way to fix bugs in stable in the above situation.

Thanks,
Jonathan
