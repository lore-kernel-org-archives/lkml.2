Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2DFS5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab2DFS5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:57:51 -0400
Message-ID: <4F7F3CA9.1030500@redhat.com>
Date: Fri, 06 Apr 2012 14:57:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ying Han <yinghan@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V8] Eliminate task stack trace duplication
References: <1333737920-17555-1-git-send-email-yinghan@google.com>
In-Reply-To: <1333737920-17555-1-git-send-email-yinghan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 02:45 PM, Ying Han wrote:
> The problem with small dmesg ring buffer like 512k is that only limited number
> of task traces will be logged. Sometimes we lose important information only
> because of too many duplicated stack traces. This problem occurs when dumping
> lots of stacks in a single operation, such as sysrq-T.
>
> This patch tries to reduce the duplication of task stack trace in the dump
> message by hashing the task stack. The hashtable is a 32k pre-allocated buffer
> during bootup. Each time if we find the identical task trace in the task stack,
> we dump only the pid of the task which has the task trace dumped. So it is easy
> to back track to the full stack with the pid.

> Signed-off-by: Ying Han<yinghan@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
