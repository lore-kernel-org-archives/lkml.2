Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1DOWsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:48:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36300
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab1DOWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:48:41 -0400
Date: Fri, 15 Apr 2011 15:48:06 -0700 (PDT)
Message-Id: <20110415.154806.245403763.davem@davemloft.net>
To: jpirko@redhat.com
Cc: rlandley@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] minor cleanup to net_namespace.c.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110415123751.GC2697@psychotron>
References: <4DA83971.7010903@parallels.com>
	<20110415123751.GC2697@psychotron>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Fri, 15 Apr 2011 14:37:52 +0200

> Fri, Apr 15, 2011 at 02:26:25PM CEST, rlandley@parallels.com wrote:
>>From: Rob Landley <rlandley@parallels.com>
>>
>>Inline a small static function that's only ever called from one place.
>>
>>Signed-off-by: Rob Landley <rlandley@parallels.com>
 ...
> Reviewed-by: Jiri Pirko <jpirko@redhat.com>

Applied.
