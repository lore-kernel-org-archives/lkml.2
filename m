Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0LWBep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:34:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50834
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505Ab0LWBeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:34:44 -0500
Date: Wed, 22 Dec 2010 17:35:13 -0800 (PST)
Message-Id: <20101222.173513.102576612.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-12-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101222195209.GD10046@tuxdriver.com>
References: <20101222195209.GD10046@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 22 Dec 2010 14:52:09 -0500

> Dave,
> 
> Three more fixes intended for 2.6.37...
> 
> The one from Johannes Berg avoids a NULL pointer dereference in the mesh
> code.  The one from Johannes Stezenbach fixes bug 24892, which is a
> lock-up caused by rt2x00.  Finally, you probably recognize the one from
> Meelis Roos which removes some log spam coming from hostap.  These have
> all spent several days in linux-next without any adverse effects.
> 
> Please let me know if there are problems!

Pulled, thanks John.
