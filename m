Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0CSCS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:18:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0CSCS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:18:56 -0400
Message-ID: <4BA2DF0B.9080600@kernel.org>
Date: Fri, 19 Mar 2010 11:18:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
References: <4BA1F2BA.30604@kernel.org>	<20100318.175413.183069013.davem@davemloft.net>	<20100319013119.GB22095@nowhere> <20100318.185757.39197211.davem@davemloft.net>
In-Reply-To: <20100318.185757.39197211.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Mar 2010 02:18:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 10:57 AM, David Miller wrote:
> I would use u64 so something like:
> 
> 	u64 [FTRACE_MAX_PROFILE_SIZE / sizeof(u64)]

<paranoid>DIV_ROUND_UP() would be safer than division</paranoid>

Thanks.

-- 
tejun
