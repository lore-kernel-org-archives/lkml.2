Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0GNTRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:17:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43564
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757173Ab0GNTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:17:29 -0400
Date: Wed, 14 Jul 2010 12:17:43 -0700 (PDT)
Message-Id: <20100714.121743.183038161.davem@davemloft.net>
To: siccegge@cs.fau.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 02/11] Removing dead {AR,WAVE}LAN
From: David Miller <davem@davemloft.net>
In-Reply-To: <3da4fcf94d2364af32c44a8442b756c8b525f6fc.1279110894.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
	<3da4fcf94d2364af32c44a8442b756c8b525f6fc.1279110894.git.siccegge@cs.fau.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 14 Jul 2010 14:39:52 +0200

> {AR,WAVE}LAN doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Applied to net-next-2.6
