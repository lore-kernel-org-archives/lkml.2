Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab1COOBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:01:10 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43524 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1COOBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:01:09 -0400
Message-ID: <4D7F7121.5040009@librato.com>
Date: Tue, 15 Mar 2011 10:01:05 -0400
From: Mike Heffner <mike@librato.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090320 Fedora/2.0.0.21-1.fc9 Lightning/0.9 Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>,
        Andrea Righi <arighi@develer.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 6/9] memcg: add cgroupfs interface to memcg dirty limits
References: <1299869011-26152-1-git-send-email-gthelen@google.com> <1299869011-26152-7-git-send-email-gthelen@google.com>
In-Reply-To: <1299869011-26152-7-git-send-email-gthelen@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 01:43 PM, Greg Thelen wrote:
> Add cgroupfs interface to memcg dirty page limits:
>    Direct write-out is controlled with:
>    - memory.dirty_ratio
>    - memory.dirty_limit_in_bytes
>
>    Background write-out is controlled with:
>    - memory.dirty_background_ratio
>    - memory.dirty_background_limit_bytes


What's the overlap, if any, with the current memory limits controlled by 
`memory.limit_in_bytes` and the above `memory.dirty_limit_in_bytes`? If 
I want to fairly balance memory between two cgroups be one a dirty page 
antagonist (dd) and the other an anonymous page (memcache), do I just 
set `memory.limit_in_bytes`? Does this patch simply provide a more 
granular level of control of the dirty limits?


Thanks,

Mike
