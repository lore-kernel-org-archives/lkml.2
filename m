Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab2JSHGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:06:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34143 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab2JSHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <1350629202-9664-7-git-send-email-wency@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com> <1350629202-9664-7-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 03:06:14 -0400
X-Google-Sender-Auth: UC7NjC5mlyBiyjfmHLCy2ZZBnHU
Message-ID: <CAHGf_=oB5bDaw4JepMuKcEUM3=GaEuy8NZb+7G4uR3=-hYh8Dg@mail.gmail.com>
Subject: Re: [PATCH v3 6/9] memory-hotplug: update mce_bad_pages when removing
 the memory
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
> When we hotremove a memory device, we will free the memory to store
> struct page. If the page is hwpoisoned page, we should decrease
> mce_bad_pages.

I think [5/9] and [6/9] should be fold. Their two patches fix one
issue. (current
hwpoison doesn't support memory offline)
