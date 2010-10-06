Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab0JFPml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:42:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab0JFPmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:42:40 -0400
Date: Wed, 6 Oct 2010 11:41:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/5] jump label: fix module __init section race
Message-ID: <20101006154140.GA2941@redhat.com>
References: <cover.1285965957.git.jbaron@redhat.com> <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com> <4CA6F44A.1000907@hitachi.com> <1286370051.6750.180.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286370051.6750.180.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 09:00:50AM -0400, Steven Rostedt wrote:
> On Sat, 2010-10-02 at 17:58 +0900, Masami Hiramatsu wrote:
> 
> > > +static void remove_module_init(struct module *mod)
> > 
> > Hi Jason,
> > 
> > Just a comment, I prefer remove_jump_label_module_init() than this name,
> > because remove_module_init is too general.
> 
> This is probably not too big of a deal since it is static, but the name
> change may make it easier for etags and ctags users.
> 
> Jason, are you OK if I pull in this patch and make the change myself?
> 
> -- Steve
> 

fine with me. I had a more specific function name and then shortened it
because it seemed too long, either way is fine with me.

thanks,

-Jason
