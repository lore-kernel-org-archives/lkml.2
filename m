Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2BXOol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:44:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26728 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2BXOok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:44:40 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=IHAw7iiUZm0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=vn4zg5DhqP2yOTB0WkEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330094677.25686.161.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] x86-64: fix CFI annotations for NMI nesting code
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Steven Rostedt <srostedt@redhat.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Date: Fri, 24 Feb 2012 09:44:37 -0500
In-Reply-To: <4F47AE7D0200007800074ABB@nat28.tlf.novell.com>
References: <4F478B630200007800074A31@nat28.tlf.novell.com>
	 <1330092690.3306.18.camel@fedora>
	 <4F47AE7D0200007800074ABB@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 14:36 +0000, Jan Beulich wrote:
>  
> > Would that work for you?
> 
> Of course, thanks for spotting this oversight of mine. I assume you
> meant the end_repeat_nmi to go after the .endr though, not before.

oops, yeah, cut and paste error ;-)

> I'll get a fixed patch sent out soon.
> 

Thanks!

-- Steve


