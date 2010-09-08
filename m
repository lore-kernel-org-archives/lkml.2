Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0IHUPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:15:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47560
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab0IHUPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:15:12 -0400
Date: Wed, 08 Sep 2010 13:15:30 -0700 (PDT)
Message-Id: <20100908.131530.102534511.davem@davemloft.net>
To: amit.kucheria@verdurent.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Conflict when compiling-in CONFIG_FIXED_PHY
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=J0gUzcj2O_MNCj=X-ZdgXgxG_ED57L7YQM+z9@mail.gmail.com>
References: <AANLkTi=J0gUzcj2O_MNCj=X-ZdgXgxG_ED57L7YQM+z9@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@verdurent.com>
Date: Wed, 8 Sep 2010 23:13:16 +0300

> I am not sure what the real fix should be - to prevent compiling-in of
> FIXED_PHY with such drivers in Kconfig or a smarter mechanism to
> assign the bus id (idr?).

Some better assignment is probably the best.
