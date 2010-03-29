Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab0C2URa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:17:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50653
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab0C2UR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:17:28 -0400
Date: Mon, 29 Mar 2010 13:17:29 -0700 (PDT)
Message-Id: <20100329.131729.125560878.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       michael.s.gilbert@gmail.com, romieu@fr.zoreil.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH] r8169: offical fix for CVE-2009-4537 (overlength frame
 DMAs)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100329160356.GC22733@hmsreliant.think-freely.org>
References: <20100329160356.GC22733@hmsreliant.think-freely.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 29 Mar 2010 12:03:56 -0400

> Official patch to fix the r8169 frame length check error.
 ...
> Signed-off-by: Neil Horman <nhorman@redhat.com>

Applied, thanks a lot Neil.
