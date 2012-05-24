Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926Ab2EXRFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:05:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38586 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440Ab2EXRFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:05:07 -0400
Date: Thu, 24 May 2012 19:04:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@amd64.org>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Remove a superfluous check
Message-ID: <20120524170459.GA5406@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Borislav Petkov <bp@amd64.org>, John Kacur <jkacur@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <1333039463-24268-1-git-send-email-bp@amd64.org>
 <alpine.LFD.2.02.1203291902280.10113@tycho>
 <20120329171140.GE6409@aftab>
 <20120524163246.GL27063@aftab.osrc.amd.com>
 <1337877710.13348.179.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1337877710.13348.179.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:41:50PM -0400, Steven Rostedt wrote:
> On Thu, 2012-05-24 at 18:32 +0200, Borislav Petkov wrote:
> > Yo Steve,
> > 
> > want to pick this one up? It still applies cleanly to current linus.
> 
> I actually have it in my 3.6 queue. It didn't look like it was urgent
> for 3.5. Is it?

Nah, I was just cleaning up my mbox and saw it.

Thanks.

-- 
Regards/Gruss,
    Boris.
