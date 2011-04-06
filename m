Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1DFTyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:54:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60447
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455Ab1DFTyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:54:20 -0400
Date: Wed, 06 Apr 2011 12:53:44 -0700 (PDT)
Message-Id: <20110406.125344.179945750.davem@davemloft.net>
To: lucian.grijincu@gmail.com
Cc: adobriyan@gmail.com, ebiederm@xmission.com, tavi@cs.pub.ro,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 02/24] sysctl: cookie: add ctl_header_cookie
From: David Miller <davem@davemloft.net>
In-Reply-To: <059405611ddd6d70415081e0261805935e95d345.1301711868.git.lucian.grijincu@gmail.com>
References: <cover.1301711868.git.lucian.grijincu@gmail.com>
	<cover.1301711868.git.lucian.grijincu@gmail.com>
	<059405611ddd6d70415081e0261805935e95d345.1301711868.git.lucian.grijincu@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Sat,  2 Apr 2011 04:53:16 +0200

> @@ -205,6 +205,7 @@ static struct ctl_table_header root_table_header = {
>  	.ctl_entry = LIST_HEAD_INIT(sysctl_table_root.default_set.list),}},
>  	.root = &sysctl_table_root,
>  	.set = &sysctl_table_root.default_set,
> +	.ctl_header_cookie = NULL,
>  };

Such explicit setting of structure members to NULL in an assignment is
never necessary.  Please remove these, there were a few cases in this
patch.

Thanks.
