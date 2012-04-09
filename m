Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2DIHxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:53:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53798 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab2DIHxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:53:42 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F8294D0.4000507@jp.fujitsu.com>
Date: Mon, 09 Apr 2012 16:50:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] mm: Allow using fast mm counters from other files
References: <1333202997-19550-1-git-send-email-andi@firstfloor.org> <1333202997-19550-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1333202997-19550-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/31 23:09), Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Allow calling inc/dec_mm_counter_fast() from other files, not just memory.c
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

