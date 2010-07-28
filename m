Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0G1Ugu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:36:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57192
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170Ab0G1Ugt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:36:49 -0400
Date: Wed, 28 Jul 2010 13:37:05 -0700 (PDT)
Message-Id: <20100728.133705.85435354.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 06/12] jump label v10: convert jump label to use a key
From: David Miller <davem@davemloft.net>
In-Reply-To: <1d0369680bbab87acfef5499e479bdc6d991ebea.1280263065.git.jbaron@redhat.com>
References: <cover.1280263065.git.jbaron@redhat.com>
	<1d0369680bbab87acfef5499e479bdc6d991ebea.1280263065.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Tue, 27 Jul 2010 16:54:32 -0400

> Convert the jump label code to use a key to identify each related set of
> jump labels instead of a string. This saves space since we no longer need
> to store strings and their pointers, just the keys. In addition we can
> simplify the JUMP_LABEL macro to 2 arguments from 3. We use the address
> of the conditional variable as the key value. If jump labels are not enabled
> then we can use the conditional variable as usual.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

It doesn't make any sense to present these changes like this.

If the final implementation of the jump label entries uses this new
key based scheme, well that's what should be in the first patch of
this series which adds the basic jump label infrastructure.

As it is, it's just commit noise.
