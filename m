Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2AKV30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:29:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121Ab2AKV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:29:24 -0500
Message-ID: <4F0DFF1C.9060801@redhat.com>
Date: Wed, 11 Jan 2012 16:29:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: deactivate isolated pages with lru lock released
References: <CAJd=RBAiAfyXBcn+9WO6AERthyx+C=cNP-romp9YJO3Hn7-U-g@mail.gmail.com>
In-Reply-To: <CAJd=RBAiAfyXBcn+9WO6AERthyx+C=cNP-romp9YJO3Hn7-U-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 07:45 AM, Hillf Danton wrote:
> Spinners on other CPUs, if any, could take the lru lock and do their jobs while
> isolated pages are deactivated on the current CPU if the lock is released
> actively. And no risk of race raised as pages are already queued on locally
> private list.
>
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

