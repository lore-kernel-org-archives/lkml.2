Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1CQMwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:52:36 -0400
Received: from lo.gmane.org ([80.91.229.12]:33308 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1CQMwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:52:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] um: Remove file pointer from ioctl
Date: Thu, 17 Mar 2011 12:52:20 +0000 (UTC)
Message-ID: <ilt063$vm1$4@dough.gmane.org>
References: <1300365449-12548-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 121.227.147.194
User-Agent: Pan/0.133 (House of Butterflies)
Cc: user-mode-linux-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 13:37:29 +0100, Richard Weinberger wrote:

> Commit 6caa76b (tty: now phase out the ioctl file pointer for good)
> removed the ioctl file pointer.
> User Mode Linux's line driver uses this ioctl and needs a signature
> update too.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

