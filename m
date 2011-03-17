Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1CQMFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:05:25 -0400
Received: from lo.gmane.org ([80.91.229.12]:35427 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab1CQMFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:05:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/2 v2] watchdog, nmi:  Allow hardlockup to panic by
 default
Date: Thu, 17 Mar 2011 12:05:11 +0000 (UTC)
Message-ID: <ilstdn$vm1$2@dough.gmane.org>
References: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 121.227.147.194
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 16:37:39 -0500, Don Zickus wrote:

> Add a Kconfig option to allow users to set the hardlockup to panic by
> default.  Also add in a 'nmi_watchdog=nopanic' to override this.
> 
> v2:
>   clean up a typo
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Looks good, I believe this is good for kdump.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

