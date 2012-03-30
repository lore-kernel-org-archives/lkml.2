Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2C3H20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:28:26 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:56245 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755342Ab2C3H2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:28:17 -0400
Date: Fri, 30 Mar 2012 09:25:21 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/5] r8169: support RTL8411
Message-ID: <20120330072521.GA11548@electric-eye.fr.zoreil.com>
References: <1333089184-1773-5-git-send-email-hayeswang@realtek.com> <1333090086-1815-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333090086-1815-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> Support the new chip RTL8411.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

I do not see any change related to rtl_init_jumbo_ops. If NULL is ok for
jumbo_{enable / disable}, it deserves to be outlined in the commit
message.

No reviewer can figure what's going on otherwise.

-- 
Ueimor
