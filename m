Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1CONqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:46:42 -0400
Received: from lo.gmane.org ([80.91.229.12]:52853 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1CONql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:46:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Restrict write access to dmesg_restrict
Date: Tue, 15 Mar 2011 13:46:28 +0000 (UTC)
Message-ID: <ilnqjj$rjj$2@dough.gmane.org>
References: <1300131356-24389-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 122.232.152.135
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 20:35:56 +0100, Richard Weinberger wrote:

> When dmesg_restrict is set to 1 CAP_SYS_ADMIN is needed to read the
> kernel ring buffer.
> But a root user without CAP_SYS_ADMIN is able to reset dmesg_restrict to
> 0.
> 
> This is an issue when e.g. LXC (Linux Containers) are used and complete
> user space is running without CAP_SYS_ADMIN. A unprivileged and jailed
> root user can bypass the dmesg_restrict protection.
> 
> With this patch writing to dmesg_restrict is only allowed when root has
> CAP_SYS_ADMIN.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Makes sense.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

