Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0KWXL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:11:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0KWXL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:11:57 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=dloADZ4KP7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=kuGs3BTuV15czDOfOUwA:9 a=Zhz3CjFe1H76h8hwL-1uiYeeizUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CEC33F6.9090808@zytor.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <4CEC33F6.9090808@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 18:11:54 -0500
Message-ID: <1290553914.30543.408.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 13:36 -0800, H. Peter Anvin wrote:
> On 11/23/2010 01:27 PM, Jason Baron wrote:
> > Hi,
> > 
> > A few jump label patches that I want considered for 2.6.37. Patches are against
> > the latest -tip tree.
> > 
> > The first one, which adds 'state' to the jump label mechanism is the most
> > important. Essentially, it ensures that if jump labels are enabled/disabled in
> > the core kernel but the actual call sites are in modules, we properly honor the
> > state of the jump label. This also works for jump labels which may be defined in
> > one module but made use of in another module.
> > 
> > There has been some discussion about using the 'key' variable to store the
> > enabled/disabled state for each jump label. However, I think a better design
> > will be to use the 'key' variable to store a pointer to the appropriate jump
> > label tables. In this way, we can enable/disable jump labels, without the
> > hashing that I'm currently doing. However, I didn't want to propose these more
> > invasive changes until 2.6.38. 
> > 
> 
> I would also like to see a change in the API, preferrably something
> closer to the "SWITCH_POINT" interface I discussed with Stephen before
> Kernel Summit.
> 

Could you explain in more detail what you would like to see.

Thanks,

-- Steve


