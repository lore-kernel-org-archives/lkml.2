Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1A0HWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:22:55 -0500
Received: from lo.gmane.org ([80.91.229.12]:33707 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1A0HWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:22:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v1 0/6] Set printk priority level
Date: Thu, 27 Jan 2011 07:22:41 +0000 (UTC)
Message-ID: <ihr6g0$qmm$3@dough.gmane.org>
References: <20110125235700.GR8008@google.com>
	<1296084570-31453-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 15:29:24 -0800, Mandeep Singh Baines wrote:

> We've been burned by regressions/bugs which we later realized could have
> been triaged quicker if only we'd paid closer attention to dmesg.
> 
> This patch series fixes printk()s which appear in the logs of the device
> I'm currently working on. I'd love to fix all such printks but there are
> hundreds of files and thousands of LOC affected:
> 
> $ find . -name \*.c | xargs fgrep -c "printk(\"" | wc -l 16237
> $ find . -name \*.c | xargs fgrep "printk(\"" | wc -l 20745
> 

Yes, this is the right approach, every printk should have a
specified level.

Thanks.

