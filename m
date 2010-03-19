Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab0CSDD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:03:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42122
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab0CSDDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:03:25 -0400
Date: Thu, 18 Mar 2010 20:03:47 -0700 (PDT)
Message-Id: <20100318.200347.115945905.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com, sparclinux@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH][GIT PULL][v2.6.34] ring-buffer: Do 8 byte alignment
 for 64 bit that can not handle 4 byte align
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268966657.758.28.camel@gandalf.stny.rr.com>
References: <1268966657.758.28.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 18 Mar 2010 22:44:17 -0400

>     Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
>                (on sparc64)
>     Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: David S. Miller <davem@davemloft.net>
