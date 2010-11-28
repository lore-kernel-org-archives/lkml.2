Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0K1TdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:33:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54398
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab0K1TdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:33:16 -0500
Date: Sun, 28 Nov 2010 11:33:43 -0800 (PST)
Message-Id: <20101128.113343.200360663.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: netdev@vger.kernel.org, paulus@samba.org, linux-ppp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6] net, ppp: Report correct error code if unit
 allocation failed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101123214344.GB1839@lenovo>
References: <20101123214344.GB1839@lenovo>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Wed, 24 Nov 2010 00:43:44 +0300

> Allocating unit from ird might return several error codes
> not only -EAGAIN, so it should not be changed and returned
> precisely. Same time unit release procedure should be invoked
> only if device is unregistering.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Looks good to me, applied, thanks Cyrill.
