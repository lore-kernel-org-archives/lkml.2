Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0LGQXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:23:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:38782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0LGQXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:23:23 -0500
Message-ID: <4CFE5F5C.5060804@kernel.org>
Date: Tue, 07 Dec 2010 17:22:52 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Subject: Re: [PATCHSET] x86: unify x86_32 and 64 NUMA init paths, take#2
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
In-Reply-To: <1290871325-3055-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 16:22:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2010 04:21 PM, Tejun Heo wrote:
> Hello,
> 
> This is the second take of unify-x86_32-and-64-NUMA-init-paths
> patchset.  Changes from the last take[L] are,
> 
> * As suggested by Ingo, 0004 from the previous series is further split
>   into 0004-0011.
> 
> * Comment noting the ugliness of x86_32 logical apicid mapping
>   difference added.

Ingo, ping?

Thanks.

-- 
tejun
