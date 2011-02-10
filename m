Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1BJCoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:44:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57235 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1BJCoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ov8TzZKb2alqHjywawFuynBDl7+7RmOtdta+LBNLs1SckvQVD8hnIxyWWXNOe/K10J
         GfA5zJwpW69oomp2F4hUsj3T+jD2hfYKguX0cYSJSkrMQjlvWIbVT7YgzLHVdSulzVG5
         qbLVOAlvE0JAxEiVAA44oNAPRKLMZHoSvXqDI=
MIME-Version: 1.0
In-Reply-To: <1297248362-23579-1-git-send-email-hannes@cmpxchg.org>
References: <1297248362-23579-1-git-send-email-hannes@cmpxchg.org>
Date: Thu, 10 Feb 2011 11:44:11 +0900
Message-ID: <AANLkTimKqORYc+fjX2hQbMAatdwR1zF43MBgnGfmTYVW@mail.gmail.com>
Subject: Re: [patch] memcg: remove memcg->reclaim_param_lock
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 7:46 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> The reclaim_param_lock is only taken around single reads and writes to
> integer variables and is thus superfluous.  Drop it.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
