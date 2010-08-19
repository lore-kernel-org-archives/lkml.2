Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0HSWMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:12:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0HSWMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:12:13 -0400
Message-ID: <4C6DAC15.7040004@redhat.com>
Date: Thu, 19 Aug 2010 18:11:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Michael Rubin <mrubin@google.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org,
        david@fromorbit.com, npiggin@suse.de, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 0/3] writeback: kernel visibility
References: <1282251447-16937-1-git-send-email-mrubin@google.com>
In-Reply-To: <1282251447-16937-1-git-send-email-mrubin@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 04:57 PM, Michael Rubin wrote:
> Patch #1 sets up some helper functions for accounting.
>
> Patch #2 adds writeback visibility in /proc/sys/vm.
>
> To help developers and applications gain visibility into writeback
> behaviour adding two read-only sysctl files into /proc/sys/vm.
> These files allow user apps to understand writeback behaviour over time
> and learn how it is impacting their performance.
>
>   # cat /proc/sys/vm/pages_dirtied
>   3747
>   # cat /proc/sys/vm/pages_entered_writeback
>   3618

Would it be better to have these values in /proc/vmstat
and /proc/zoneinfo ?

I don't really see why they need to be in /proc/sys
at all...

-- 
All rights reversed
