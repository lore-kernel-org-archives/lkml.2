Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0FYOKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:10:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab0FYOKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:10:42 -0400
Message-ID: <4C24B8DA.3000706@redhat.com>
Date: Fri, 25 Jun 2010 10:10:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan: zone_reclaim don't call disable_swap_token()
References: <20100625173002.8052.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100625173002.8052.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 04:31 AM, KOSAKI Motohiro wrote:
> Swap token don't works when zone reclaim is enabled since it was born.
> Because __zone_reclaim() always call disable_swap_token()
> unconditionally.
>
> This kill swap token feature completely. As far as I know, nobody want
> to that. Remove it.
>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Christoph Lameter<cl@linux-foundation.org>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

You are absolutely right.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
