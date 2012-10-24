Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808Ab2JXNjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:39:06 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:4657 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934541Ab2JXNjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:39:03 -0400
Date: Wed, 24 Oct 2012 13:39:01 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mel Gorman <mgorman@suse.de>,
        "'FNST-Wen Congyang'" <wency@cn.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2 V2] slub, hotplug: ignore unrelated node's hot-adding
 and hot-removing
In-Reply-To: <1351071840-5060-3-git-send-email-laijs@cn.fujitsu.com>
Message-ID: <0000013a92ff635f-6f359d39-eb8d-44e9-b6fc-0925a09e8da2-000000@email.amazonses.com>
References: <1351071840-5060-1-git-send-email-laijs@cn.fujitsu.com> <1351071840-5060-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Lai Jiangshan wrote:

> SLUB only fucus on the nodes which has normal memory, so ignore the other
> node's hot-adding and hot-removing.

As far as I can see the reasoning sounds fine and the patch looks clean.

Acked-by: Christoph Lameter <cl@linux.com>
