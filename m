Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0DVXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 19:16:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57360
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914Ab0DVXQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:16:56 -0400
Date: Thu, 22 Apr 2010 16:17:00 -0700 (PDT)
Message-Id: <20100422.161700.191166551.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 00/11] jump label v7
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1271427118.git.jbaron@redhat.com>
References: <cover.1271427118.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Fri, 16 Apr 2010 11:24:10 -0400

> David, I re-worked the sparc64 to match the updated interfaces. The
> code should hopefully compile now, although I did not test the sparc
> bits.

Thanks for working on this Jason.  I'll take a close look at this
some time today.
