Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0KHAB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 19:01:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36395 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0KHABz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 19:01:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NW9v55AjQMj1Dqi7FlSsCbj0BmJ3yb3GbJA/r2M1DGcPUyxUSiSGSOewZaWS0AHOzk
         3MJ/jvcr1vDS8JymIBxiK+Xb0Btag8W2Fj7gUn0RlnhD8JpmzsGUf6gSloCG9MbncyV/
         YIHTSrrIMM+R/NdNJ4YRzl26Gs+RlCXzb3S1k=
MIME-Version: 1.0
In-Reply-To: <20101107220353.964566018@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
	<20101106010357.GD23393@cmpxchg.org>
	<AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
	<20101107215030.007259800@cmpxchg.org>
	<20101107220353.964566018@cmpxchg.org>
Date: Mon, 8 Nov 2010 09:01:54 +0900
Message-ID: <AANLkTinLK5DiG3ZkEFSAJNZrPKK7aXiPPYQ6z9M6RPhc@mail.gmail.com>
Subject: Re: [patch 4/4] memcg: use native word page statistics counters
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 7:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> The statistic counters are in units of pages, there is no reason to
> make them 64-bit wide on 32-bit machines.
>
> Make them native words.  Since they are signed, this leaves 31 bit on
> 32-bit machines, which can represent roughly 8TB assuming a page size
> of 4k.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

This patch changes mem_cgroup_recursive_idx_stat with
mem_cgroup_recursive_stat as well.
As you know, It would be better to be another patch although it's
trivial. But I don't mind it.
I like the name. :)

Thanks, Hannes.





-- 
Kind regards,
Minchan Kim
