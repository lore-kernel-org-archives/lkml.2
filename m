Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0LGQ2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:28:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab0LGQ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:28:01 -0500
Message-ID: <4CFE6024.6000902@redhat.com>
Date: Tue, 07 Dec 2010 11:26:12 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC][PATCH 02/10] mm: Remove likely() from mapping_unevictable()
References: <20101207015834.196176991@goodmis.org>	 <20101207021328.569328536@goodmis.org> <1291688533.16223.119.camel@gandalf.stny.rr.com>
In-Reply-To: <1291688533.16223.119.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 09:22 PM, Steven Rostedt wrote:

> The unlikely in page_mapping() was correct a total of 1909540379 times and
> incorrect 1270533123 times, with a 39% being incorrect. Perhaps this is
> enough to remove the unlikely from page_mapping() as well.
>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Nick Piggin<nickpiggin@yahoo.com.au>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Lee Schermerhorn<Lee.Schermerhorn@hp.com>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
