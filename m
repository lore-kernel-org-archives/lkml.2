Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1FUDgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 23:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1FUDgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 23:36:13 -0400
Message-ID: <4E0011A0.4070401@redhat.com>
Date: Tue, 21 Jun 2011 11:36:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165844.GA9396@suse.de> <4DFF7E3B.1040404@redhat.com> <4DFF7F0A.8090604@redhat.com> <4DFF8106.8090702@redhat.com> <4DFF8327.1090203@redhat.com> <4DFF84BB.3050209@redhat.com> <20110620175859.GB9697@mgebm.net>
In-Reply-To: <20110620175859.GB9697@mgebm.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 01:58, Eric B Munson 写道:
> If memory is this scarce, why not set CONFIG_TRANSPARENT_HUGEPAGE=n and be done
> with it?  If the config option is enabled, the admin should be able to turn the
> functionality back on if desired.  If you really don't _ever_ want THP then
> disable the config.
>

Unfortunately, changing .config is not always as easy as you said,
for the kdump case, we use the same kernel binary with the normal kernel
which certainly has to have THP enabled in .config.

Thanks.
