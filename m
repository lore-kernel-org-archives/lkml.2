Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2LQLTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:19:09 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:65394 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2LQLTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:19:07 -0500
Date: Mon, 17 Dec 2012 03:19:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, mingo@elte.hu, penberg@kernel.org,
        torvalds@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] memory-hotplug: Disable CONFIG_MOVABLE_NODE option
 by default.
In-Reply-To: <1355708488-2913-3-git-send-email-tangchen@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1212170318110.21139@chino.kir.corp.google.com>
References: <1355708488-2913-1-git-send-email-tangchen@cn.fujitsu.com> <1355708488-2913-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, Tang Chen wrote:

> This patch set CONFIG_MOVABLE_NODE to "default n" instead of
> "depends on BROKEN".
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

It's fine to change the default, but what's missing here is a rationale 
for no longer making it depend on CONFIG_BROKEN.
