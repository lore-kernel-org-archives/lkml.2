Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab0HPIGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:06:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51070 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0HPIGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:06:24 -0400
Message-ID: <4C68F0D4.7030300@kernel.org>
Date: Mon, 16 Aug 2010 10:03:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] CMWQ: Set workqueue name before we process one work.
References: <1281944355-4379-1-git-send-email-tao.ma@oracle.com> <4C68EC76.70903@kernel.org> <4C68F0BA.5050905@oracle.com>
In-Reply-To: <4C68F0BA.5050905@oracle.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 08:06:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/16/2010 10:03 AM, Tao Ma wrote:
>> I thought about the same thing but this doesn't provide any more
>> information than stack traces for debugging and for run time tracking
>> implementing tracing API (scheduled to be added in this devel cycle)
>> is the right approach.
>
> Do you have the link for this or it will show up in the mail list soon?

Oh, it's just on top of cmwq todo list.  fscache needs it too so it
will definitely happen sooner than later.  I'll try to remember to cc
eyou when I post patches.

Thanks.

-- 
tejun
