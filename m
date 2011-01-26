Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1AZETE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:19:04 -0500
Received: from lo.gmane.org ([80.91.229.12]:40146 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1AZETD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:19:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Date: Wed, 26 Jan 2011 04:18:50 +0000 (UTC)
Message-ID: <iho7ba$kmn$1@dough.gmane.org>
References: <20110125235700.GR8008@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 15:57:00 -0800, Mandeep Singh Baines wrote:

> We've been burned by regressions/bugs which we later realized could have
> been triaged quicker if only we'd paid closer attention to dmesg. To
> make it easier to audit dmesg, we'd like to make DEFAULT_MESSAGE_LEVEL
> Kconfig-settable. That way we can set it to KERN_NOTICE and audit any
> messages <= KERN_WARNING.
> 

Why? We already have "loglevel=" kernel parameter.

