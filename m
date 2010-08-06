Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288Ab0HFLqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:46:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab0HFLqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:46:44 -0400
Date: Fri, 6 Aug 2010 13:46:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, rostedt@goodmis.org, yhlu.kernel@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] apic: tracing IPI events
Message-ID: <20100806114611.GE1981@jolsa.brq.redhat.com>
References: <1281006578-5073-1-git-send-email-jolsa@redhat.com>
 <87bp9gc783.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bp9gc783.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:26:36PM +0200, Andi Kleen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> >
> > please let me know what you think
> 
> You forgot to state why you want it?
> 
> In generall the only case that should happen anytime commonly is mask,
> the others only for obscure uncommon paths.
> 
> However there is already accounting for it in /proc/interrupts
> that can be easily sampled. Does adding additional tracing really give 
> any value?

As I was asked to do that for other guys, I'm not completely sure.
Anyway the reason I got was, that while debuging crash it seemed 
some IPIs might got lost.

Also it'd be probably used as a tracepoint itself via additional code,
than by ring buffer tracing.

I'll check if I can get more justifing info..

jirka

> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
