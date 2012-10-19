Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2JSHHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:07:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46209 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2JSHHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <1350629202-9664-10-git-send-email-wency@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com> <1350629202-9664-10-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 03:07:24 -0400
X-Google-Sender-Auth: WjEsKN8yCw8TJmnA5zb9icbOZEY
Message-ID: <CAHGf_=q_chfJQ+dWHdA8v5+qCCs=_EhdHL0J2hX=_Fr8xJiTVQ@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] memory-hotplug: allocate zone's pcp before
 onlining pages
To: wency@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 2:46 AM,  <wency@cn.fujitsu.com> wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> We use __free_page() to put a page to buddy system when onlining pages.
> __free_page() will store NR_FREE_PAGES in zone's pcp.vm_stat_diff, so we
> should allocate zone's pcp before onlining pages, otherwise we will lose
> some free pages.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

Looks good.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
