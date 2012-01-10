Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2AJFkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 00:40:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab2AJFkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 00:40:23 -0500
Message-ID: <4F0BCF3B.4050901@redhat.com>
Date: Tue, 10 Jan 2012 00:40:11 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: vmscan: cleanup with s/reclaim_mode/isolate_mode/
References: <CAJd=RBBifQggNFtBsq0-Q_fG6mOJ-rJ544Me9pLFXbMi3Xn0gQ@mail.gmail.com>
In-Reply-To: <CAJd=RBBifQggNFtBsq0-Q_fG6mOJ-rJ544Me9pLFXbMi3Xn0gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 09:01 AM, Hillf Danton wrote:
> With tons of reclaim_mode(defined as one field of struct scan_control) already
> in the file, it is clearer to rename it when setting up the isolation mode.
>
>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
