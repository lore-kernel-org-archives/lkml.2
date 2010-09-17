Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0IQSVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:21:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40233
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab0IQSVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:21:01 -0400
Date: Fri, 17 Sep 2010 11:21:19 -0700 (PDT)
Message-Id: <20100917.112119.141239689.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
	<ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Fri, 17 Sep 2010 11:09:00 -0400

> base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
> assembly gcc mechanism, we can now branch to labels from an 'asm goto'
> statment. This allows us to create a 'no-op' fastpath, which can subsequently
> be patched with a jump to the slowpath code. This is useful for code which
> might be rarely used, but which we'd like to be able to call, if needed.
> Tracepoints are the current usecase that these are being implemented for.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
