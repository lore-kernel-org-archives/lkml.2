Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KJAv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:51:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55852 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0KJAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IjJijTP2OMpsLYohvheWhppeKfUMPHSCyfMpC4JK+kzv2GMhgpAN5mUTvJth/eIJOJ
         AMVzI+juzVTv4GZggi75RWk6v1u3G9MTkJccRgNyHTJebY5T62agsehaT3sdV+gMuuCx
         +Kq6k7VOJPzF+pXVJ/HF1JqGM9g/gNz7q8LY0=
MIME-Version: 1.0
In-Reply-To: <1289294671-6865-2-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-2-git-send-email-gthelen@google.com>
Date: Wed, 10 Nov 2010 09:51:23 +0900
Message-ID: <AANLkTikteK-3gVghEu7egfUH+Ngfm1e7aQMyz1KBZ0nT@mail.gmail.com>
Subject: Re: [PATCH 1/6] memcg: add mem_cgroup parameter to mem_cgroup_page_stat()
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:24 PM, Greg Thelen <gthelen@google.com> wrote:
> This new parameter can be used to query dirty memory usage
> from a given memcg rather than the current task's memcg.
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
