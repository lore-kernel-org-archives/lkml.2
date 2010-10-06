Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab0JFNA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:00:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab0JFNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:00:56 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=-tYYMGhhkdgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SVbljbAVUH09fqSSTXwA:9 a=JLR-upzFSH4x10y_-WSOg_tQ6scA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/5] jump label: fix module __init section race
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <4CA6F44A.1000907@hitachi.com>
References: <cover.1285965957.git.jbaron@redhat.com>
	 <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>
	 <4CA6F44A.1000907@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Oct 2010 09:00:50 -0400
Message-ID: <1286370051.6750.180.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-02 at 17:58 +0900, Masami Hiramatsu wrote:

> > +static void remove_module_init(struct module *mod)
> 
> Hi Jason,
> 
> Just a comment, I prefer remove_jump_label_module_init() than this name,
> because remove_module_init is too general.

This is probably not too big of a deal since it is static, but the name
change may make it easier for etags and ctags users.

Jason, are you OK if I pull in this patch and make the change myself?

-- Steve


