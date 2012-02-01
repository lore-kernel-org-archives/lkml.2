Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2BACKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 21:10:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2BACKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 21:10:01 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=JI1lpQ6egjYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=cNnv_w7zcwIUaCsOutwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328062199.5882.54.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
From: Steven Rostedt <rostedt@goodmis.org>
To: Indan Zupancic <indan@nul.nu>
Cc: takuo.koguchi.sw@hitachi.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        fweisbec@gmail.com, mingo@redhat.com, jbaron@redhat.com,
        yrl.pp-manager.tt@hitachi.com, mcgrathr@google.com
Date: Tue, 31 Jan 2012 21:09:59 -0500
In-Reply-To: <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
	 <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 02:47 +0100, Indan Zupancic wrote:
> > +#define _TIF_SYSCALL_T_OR_A  (_TIF_SYSCALL_TRACE |
> _TIF_SYSCALL_TRACEPOINT)
> 
> What does 'A' stand for?
> 
Maybe he meant it to be TIF_SYSCALL_T_AND_A?

;-)

-- Steve


