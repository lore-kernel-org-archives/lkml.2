Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1DGO0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:26:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65438 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1DGO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=K1B9ZpWpCsfThvHxM9m8d+RKmTCBBcuJsC+ND7IeyyYU0Uc7R/fLC0+VTexwiyfiI1
         54I5t3b4vh5brerJXB0Hk4jOXAnmjQqMUjpmteXfgiM/EcnlDW4d4K0PBwEUpgwrSHcO
         uXEMauHOdv6XGU+1K0YEBu/7WBXGVNcAYsyiA=
Date: Thu, 7 Apr 2011 16:26:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH perf 0/2] perf: trace-event-parse: support more
 operators and print formats
Message-ID: <20110407142605.GC1798@nowhere>
References: <1300746846-28245-1-git-send-email-dhsharp@google.com>
 <BANLkTimhAis_f5OXgzfMD7uKeX5qHYUsgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimhAis_f5OXgzfMD7uKeX5qHYUsgA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 07:01:40PM -0700, David Sharp wrote:
> Hi, any feedback on these patches? I think it's important that perf
> and trace-cmd don't drift in the syntax they accept.
> 
> d#

Sorry, I forgot these.
 
> On Mon, Mar 21, 2011 at 3:34 PM, David Sharp <dhsharp@google.com> wrote:
> > These patches correspond to similar patches recently applied to trace-cmd
> >
> > [ Re-sending with more Cc's ]
> >
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Stephane Eranian <eranian@google.com>
> >
> >
> > David Sharp (2):
> >  perf: trace-event-parse: support additional operators: '!', '~',  and
> >    '!='
> >  perf: trace-event-parse: support printing short fields

So we now have trace events that use these new operations? Which ones?
A quick grep on "TP_printk" and "!" doesn't give me any result, probably
because TP_printk is often multiline.
