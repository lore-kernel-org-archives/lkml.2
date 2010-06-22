Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0FVSVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:21:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0FVSVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:21:45 -0400
Message-ID: <4C20FF34.3080208@redhat.com>
Date: Tue, 22 Jun 2010 14:21:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [Patch] Call cond_resched() at bottom of main look in balance_pgdat()
References: <1276800520.8736.236.camel@dhcp-100-19-198.bos.redhat.com> <20100618093954.FBE7.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100618093954.FBE7.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 07:45 AM, KOSAKI Motohiro wrote:

> kosaki note: This seems regression caused by commit bb3ab59683
> (vmscan: stop kswapd waiting on congestion when the min watermark is
>   not being met)
> 
> Signed-off-by: Larry Woodman<lwoodman@redhat.com>
> Reviewed-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>
