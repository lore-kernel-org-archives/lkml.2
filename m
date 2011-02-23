Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1BWPml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:42:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1BWPmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:42:40 -0500
Subject: Re: [PATCH] jump label: introduce static_branch() interface
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, hpa@zytor.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <1298475628.7666.88.camel@gandalf.stny.rr.com>
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
	 <1298475628.7666.88.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 16:42:01 +0100
Message-ID: <1298475721.2217.779.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 10:40 -0500, Steven Rostedt wrote:
> Shouldn't this be CONFIG_JUMP_LABEL?

No, stare at the mess that is: CC_HAVE_ASM_GOTO ;-)
