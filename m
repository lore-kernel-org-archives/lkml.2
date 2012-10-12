Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2JLCm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:42:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2JLCm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:42:28 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=J7ERXNQwqmwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=P3xNwfJ5JkoA:10 a=1XWaLZrsAAAA:8 a=anCn2-uM0frOQm8v_IgA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=UTB_XpHje0EA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350009746.24256.84.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] tracing: trivial cleanup
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 22:42:26 -0400
In-Reply-To: <CAJL_ektrdqwBoUYj9yoXn8FUaY7n+FmsVKHaosZtcX9yhobeHg@mail.gmail.com>
References: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
	 <1350007016.24256.82.camel@gandalf.local.home>
	 <CAJL_ektrdqwBoUYj9yoXn8FUaY7n+FmsVKHaosZtcX9yhobeHg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 19:31 -0700, David Sharp wrote:
> On Thu, Oct 11, 2012 at 6:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Sorry, I know this is late, but it was pushed down in my todo list
> > (never off, but something I probably wouldn't have seen for a few more
> > months).
> >
> > On Thu, 2012-06-07 at 16:46 -0700, Vaibhav Nagarnaik wrote:
> >> From: David Sharp <dhsharp@google.com>
> >
> > If this is from David it needs his SOB.
> 
> Is that true even though we are working for the same company?
> 

Yes.

I would never push a patch from Ingo without his Signed-off-by even
though he and I work for the same company ;-)

Although, the GPL would let you. But it's best not to do it.

-- Steve


