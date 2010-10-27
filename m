Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0J0VPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:15:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44988
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203Ab0J0VPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:15:16 -0400
Date: Wed, 27 Oct 2010 14:15:38 -0700 (PDT)
Message-Id: <20101027.141538.193709095.davem@davemloft.net>
To: jbaron@redhat.com
Cc: rostedt@goodmis.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, ddaney@caviumnetworks.com,
        dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1288212485.git.jbaron@redhat.com>
References: <cover.1288212485.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Wed, 27 Oct 2010 17:07:08 -0400

> So we finally tracked down the jump label crashes and it turned out that there
> was a a bug in the compiler in the implementation of 'asm goto'. As the fix has
> not yet been committed yet to gcc, and I don't have a simple test case to
> check if the bug has been fixed, we are going to disable jump labels pending
> a better test to detect that gcc has been fixed.
> 
> The second patch fixes a hang on Geode LX, b/c the no-op probing was done too
> early - before the exception tables had even been setup.

Please don't lose the sparc section alignment bug fix I posted recently.
