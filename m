Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964Ab0J2Uoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:44:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761942Ab0J2Uow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:44:52 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=ygIiTo8ZIjQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cHTspt_pFYjhbIXOOdAA:9 a=Z1lId8sNfktSbUpjmQNUXT7C3Q0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        David Daney <ddaney@caviumnetworks.com>, rth@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101029200538.GA25682@Krystal>
References: <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>
	 <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu>
	 <1288354687.18238.433.camel@gandalf.stny.rr.com>
	 <20101029122230.GA25663@elte.hu>
	 <1288356418.18238.454.camel@gandalf.stny.rr.com>
	 <20101029133524.GA23916@Krystal>
	 <1288369108.29632.1.camel@gandalf.stny.rr.com>
	 <20101029200538.GA25682@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Oct 2010 16:44:49 -0400
Message-ID: <1288385089.29632.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 16:05 -0400, Mathieu Desnoyers wrote:

> > > The rest looks fine,
> > 
> > Great, can I add your acked-by then?
> 
> As noted in my other email, please do :)

Crap, I pushed it out already. Well, I have you Cc'd.

-- Steve


