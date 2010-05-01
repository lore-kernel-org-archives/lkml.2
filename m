Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0EAWKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 18:10:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40882
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab0EAWKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 18:10:17 -0400
Date: Sat, 01 May 2010 15:10:22 -0700 (PDT)
Message-Id: <20100501.151022.190375136.davem@davemloft.net>
To: orenl@cs.columbia.edu
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, serue@us.ibm.com, matthltc@us.ibm.com,
       xemul@openvz.org, sukadev@linux.vnet.ibm.com, linux-api@vger.kernel.org,
       x86@kernel.org, linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
	<1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NO WAY, there is no way in the world you should post 100 patches
at a time to any mailing list, especially those at vger.kernel.org
that have thousands upon thousands of subscribers.

Post only small, well contained, sets of patches at a time.  At most
10 or so in one go.

Do you realize how much mail traffic you generate by posting so many
patches at one time, and how unlikely it is for anyone to actually
sift through and review your patches after you've spammed them by
posting so many at one time?

A second infraction and I will have no choice but to block you at the
SMTP level at vger.kernel.org so please do not do it again.

Thanks.
