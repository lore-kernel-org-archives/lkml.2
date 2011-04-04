Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1DDVDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:03:50 -0400
Received: from mail.digium.com ([216.207.245.2]:52392 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab1DDVDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:03:48 -0400
X-Greylist: delayed 1479 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 17:03:48 EDT
Message-ID: <4D9A2C6B.6020607@digium.com>
Date: Mon, 04 Apr 2011 15:39:07 -0500
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: "wanlong.gao" <wanlong.gao@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: X86_32: Got a kernel panic when poweroff
References: <201104050339475463862@gmail.com>
In-Reply-To: <201104050339475463862@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 02:39 PM, wanlong.gao wrote:
> Hi , all
> When I did poweroff or reboot .
> It got a kernel panic .
> I just have several pictures about these panic .
> I tried to fix it , but I can't do .
> 
> Here are the pictures .
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_1.jpg
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_2.png
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_3.png
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_4.png
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_5.png
> 

I was running into something similar myself and my issue was resolved in
commit 4ac5fc6a3e4d90120f292526bcaa5ee182a7411b from this morning.

Here is a link to the commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4ac5fc6a3e4d90120f292526bcaa5ee182a7411b

-- 
Shaun Ruffell
Digium, Inc. | Linux Kernel Developer
445 Jan Davis Drive NW - Huntsville, AL 35806 - USA
Check us out at: www.digium.com & www.asterisk.org
