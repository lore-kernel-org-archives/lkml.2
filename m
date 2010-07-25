Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0GYXsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 19:48:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42839
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab0GYXsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 19:48:38 -0400
Date: Sun, 25 Jul 2010 16:48:55 -0700 (PDT)
Message-Id: <20100725.164855.193718303.davem@davemloft.net>
To: bugzilla@tut.by, andrew@beldisplaytech.com
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3c59x: Add ethtool WOL support
From: David Miller <davem@davemloft.net>
In-Reply-To: <201007250524.18911.andrew@beldisplaytech.com>
References: <201007250524.18911.andrew@beldisplaytech.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Andrew O. Shadoura" <andrew@beldisplaytech.com>
Date: Sun, 25 Jul 2010 05:24:17 +0300

> This patch adds wrappers for ethtool to get or set wake-on-LAN 
> setting without re-inserting the kernel module.
> 
> Signed-off-by: Andrew O. Shadoura <andrew@beldisplaytech.com>

Applied, thanks.
