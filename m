Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1C3KgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:36:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40142
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017Ab1C3KgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:36:07 -0400
Date: Wed, 30 Mar 2011 03:35:29 -0700 (PDT)
Message-Id: <20110330.033529.71582712.davem@davemloft.net>
To: rlandley@parallels.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@kernel.org
Subject: Re: 2.6.38 containers bug: Infinite loop in
 /proc/sys/net/ipv6/neigh/neigh/neigh...
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D9302F3.6080206@parallels.com>
References: <4D92E9DC.3070405@parallels.com>
	<20110330.020120.02272125.davem@davemloft.net>
	<4D9302F3.6080206@parallels.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>
Date: Wed, 30 Mar 2011 05:16:19 -0500

> Pinging the stable guys to make sure this goes in a dot release.

Please do not do this.

I let fixes soak in Linus's tree for a week or even more before I submit
them to -stable.
