Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0J1Bdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 21:33:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab0J1Bdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 21:33:44 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=hP5unB6w35oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=ptZ5_ZwvWdonOW_7qwUA:9 a=MLoCo28ro2lf_o5hiBoA:7 a=T6uuljkteQlcDeB-NJFpJl1BvikA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label updates
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: jbaron@redhat.com, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, ddaney@caviumnetworks.com,
        dsd@laptop.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101027.141538.193709095.davem@davemloft.net>
References: <cover.1288212485.git.jbaron@redhat.com>
	 <20101027.141538.193709095.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 21:33:40 -0400
Message-ID: <1288229620.18238.131.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 14:15 -0700, David Miller wrote:
> From: Jason Baron <jbaron@redhat.com>
> Date: Wed, 27 Oct 2010 17:07:08 -0400
> 
> > So we finally tracked down the jump label crashes and it turned out that there
> > was a a bug in the compiler in the implementation of 'asm goto'. As the fix has
> > not yet been committed yet to gcc, and I don't have a simple test case to
> > check if the bug has been fixed, we are going to disable jump labels pending
> > a better test to detect that gcc has been fixed.
> > 
> > The second patch fixes a hang on Geode LX, b/c the no-op probing was done too
> > early - before the exception tables had even been setup.
> 
> Please don't lose the sparc section alignment bug fix I posted recently.

I wont, I'm currently busy doing my RH job ;-) I'll have it already
queued up, and will post later tonight.

-- Steve


