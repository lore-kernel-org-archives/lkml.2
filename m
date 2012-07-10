Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2GJFf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:35:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37990 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2GJFf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:35:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120709142936.GB17314@barrios>
References: <1340783514-8150-1-git-send-email-minchan@kernel.org>
	<1340783514-8150-3-git-send-email-minchan@kernel.org>
	<CAEtiSavGmp=V37jxmLm2eQyRP3F08KotF9Dma5JCn7uaJbPo+w@mail.gmail.com>
	<20120709142936.GB17314@barrios>
Date: Tue, 10 Jul 2012 11:05:26 +0530
Message-ID: <CAEtiSau+=dUfqBTjuJbdjNsnh_-cay6HCSuZKpZ=mVR6-ouVTQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] memory-hotplug: fix kswapd looping forever problem
From: Aaditya Kumar <aaditya.kumar.30@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mgorman@suse.de>, tim.bird@am.sony.com,
        frank.rowand@am.sony.com, takuzo.ohara@ap.sony.com,
        kan.iibuchi@jp.sony.com, aaditya.kumar@ap.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 7:59 PM, Minchan Kim <minchan@kernel.org> wrote:

Hello Minchan,

> May I add your tested-by in next spin which will include automatic type conversion
> problem ?

Yeah sure.
