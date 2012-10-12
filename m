Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2JLGHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:07:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32984 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2JLGHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:07:22 -0400
Date: Fri, 12 Oct 2012 08:07:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: trivial cleanup
Message-ID: <20121012060717.GB9881@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Sharp <dhsharp@google.com>,
	Vaibhav Nagarnaik <vnagarnaik@google.com>,
	linux-kernel@vger.kernel.org
References: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
 <1350007016.24256.82.camel@gandalf.local.home>
 <CAJL_ektrdqwBoUYj9yoXn8FUaY7n+FmsVKHaosZtcX9yhobeHg@mail.gmail.com>
 <1350009746.24256.84.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350009746.24256.84.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:42:26PM -0400, Steven Rostedt wrote:
> On Thu, 2012-10-11 at 19:31 -0700, David Sharp wrote:
> > On Thu, Oct 11, 2012 at 6:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > Sorry, I know this is late, but it was pushed down in my todo list
> > > (never off, but something I probably wouldn't have seen for a few more
> > > months).
> > >
> > > On Thu, 2012-06-07 at 16:46 -0700, Vaibhav Nagarnaik wrote:
> > >> From: David Sharp <dhsharp@google.com>
> > >
> > > If this is from David it needs his SOB.
> > 
> > Is that true even though we are working for the same company?
> > 
> 
> Yes.
> 
> I would never push a patch from Ingo without his Signed-off-by even
> though he and I work for the same company ;-)
> 
> Although, the GPL would let you. But it's best not to do it.

I'd say that it is even a no-no. The SOB chain denotes author - possible
intermediary handler as in this case - committer and we all feel very
strongly (I'm told :-)) about stating the exact origin and path upstream
of every patch. So it is not only an authorship issue.

-- 
Regards/Gruss,
    Boris.
