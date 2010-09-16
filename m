Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0IPGsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:48:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39674 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0IPGsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:48:03 -0400
Message-ID: <4C91BDA5.2090308@kernel.dk>
Date: Thu, 16 Sep 2010 08:48:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com
Subject: Re: [RFC PATCH] Block device bio throttling support [V3]
References: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-15 23:06, Vivek Goyal wrote:
> Hi,
> 
> This is V3 of the bio throttling patches. Following are changes since V2.
> 
> - Added the support for throttling in terms of IOPS (READ/WRITE). If one
>   specifies both bandwidth as well as IOPS rules on a device then IO is
>   subjected to both the rules.
> 
> - Did few bug fixes.
> 
> - Did some cleanups in blk-cgroup code.

Vivek, I have merged these patches now to get some exposure and
testing before .37 gets too close.

-- 
Jens Axboe

