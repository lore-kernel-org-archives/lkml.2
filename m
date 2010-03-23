Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0CWE4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:56:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44066
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab0CWE4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:56:41 -0400
Date: Mon, 22 Mar 2010 21:57:03 -0700 (PDT)
Message-Id: <20100322.215703.77339158.davem@davemloft.net>
To: amwang@redhat.com
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, shemminger@linux-foundation.org,
       bonding-devel@lists.sourceforge.net, fubar@us.ibm.com
Subject: Re: [RFC Patch 2/3] bridge: make bridge support netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA84607.7030304@redhat.com>
References: <4BA82186.3010204@redhat.com>
	<1269318470.3552.54.camel@calx>
	<4BA84607.7030304@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Tue, 23 Mar 2010 12:39:35 +0800

> How could you let the bridge know netpoll is not sent to
> the one that doesn't support netpoll during setup? This will
> be complex, I am afraid.

Why does this matter at all?

I told you in another mail that we should do away with
these callbacks and all the crazy 'npinfo' assignments
and just do it in the generic code.
