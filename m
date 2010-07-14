Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0GNUlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:41:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49297
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419Ab0GNUlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:41:45 -0400
Date: Wed, 14 Jul 2010 13:42:00 -0700 (PDT)
Message-Id: <20100714.134200.189714136.davem@davemloft.net>
To: siccegge@cs.fau.de
Cc: jpirko@redhat.com, eric.dumazet@gmail.com, jesper.nilsson@axis.com,
        tj@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 09/11] Removing dead ETRAX_NETWORK_RED_ON_NO_CONNECTION
From: David Miller <davem@davemloft.net>
In-Reply-To: <d8e76e2563bb1ced76b1629859a7dc02e8f2523c.1279110895.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
	<d8e76e2563bb1ced76b1629859a7dc02e8f2523c.1279110895.git.siccegge@cs.fau.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 14 Jul 2010 14:41:20 +0200

> ETRAX_NETWORK_RED_ON_NO_CONNECTION doesn't exist in Kconfig, therefore
> removing all references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Applied.
