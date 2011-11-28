Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1K1Hpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:45:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1K1Hpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:45:34 -0500
Message-ID: <4ED33C0D.3020001@redhat.com>
Date: Mon, 28 Nov 2011 15:45:17 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 16/62] infiniband: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-17-git-send-email-amwang@redhat.com> <CAL1RGDXkh4xJJNO+7fkDXJ4f7LgwvbrHKTueiozUkiK0dkRBZA@mail.gmail.com>
In-Reply-To: <CAL1RGDXkh4xJJNO+7fkDXJ4f7LgwvbrHKTueiozUkiK0dkRBZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月28日 15:38, Roland Dreier 写道:
> These look fine, given the second argument is unused.  So
>
> Acked-by: Roland Dreier<roland@purestorage.com>
>

Thanks, Roland!

> ... or is there some point when the<linux/highmem.h>  part is
> going in and where it makes sense for me to apply this through
> my tree?
>

I think this patchset should be taken as a whole, so either Andrew
takes them all, or let Stephen to merge my tree[1] to linux-next.

But I don't know if Andrew has different opinions.

1. git://github.com/congwang/linux.git #for-next
