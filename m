Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1B1AJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 19:09:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39999
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833Ab1B1AJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 19:09:02 -0500
Date: Sun, 27 Feb 2011 16:09:39 -0800 (PST)
Message-Id: <20110227.160939.15232361.davem@davemloft.net>
To: rweikusat@mobileactivedefense.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix multithreaded signal handling in unix recv
 routines
From: David Miller <davem@davemloft.net>
In-Reply-To: <874o83bmkj.fsf@sapphire.mobileactivedefense.com>
References: <874o83bmkj.fsf@sapphire.mobileactivedefense.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Networking patches should be submitted to netdev@vger.kernel.org,
since that is where the networking developers listen and it's
also the mailing list that will get your patch properly tracked
in patchwork at:

	http://patchwork.ozlabs.org/project/netdev/

so that it doesn't get lost.

Thanks.
