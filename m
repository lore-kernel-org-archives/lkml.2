Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1EBRHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:07:40 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37292 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab1EBRHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:07:38 -0400
Date: Mon, 2 May 2011 19:07:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Valdis.Kletnieks@vt.edu, bp@alien8.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
Message-ID: <20110502170736.GB18740@merkur.ravnborg.org>
References: <71633.1304013549@localhost> <1304083893-18849-1-git-send-email-mmarek@suse.cz> <BANLkTikMf4x0e3UhabUH+c_xnWJMQ3rkvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikMf4x0e3UhabUH+c_xnWJMQ3rkvg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 12:16:15AM +0800, Américo Wang wrote:
> On Fri, Apr 29, 2011 at 9:31 PM, Michal Marek <mmarek@suse.cz> wrote:
> > Add support for make W=12, make W=123 and so on, to enable warnings from
> > multiple W= levels. Normally, make W=<level> does not include warnings
> > from the previous level.
> >
> 
> This interface is not friendly, at least not as normal as we often see.
> W=x+1 is supposed to include warnings of W=x.
> 
> Please refine the interface.

Until we see that several people have had benefit if W=...
we should leave it as is now.

Then when people really start to use if we can refine it.

IMO it is much more important to find the right sub-set
of warnings to keep on W=1 level than how we see additional warnings.

There may well be warnings where we say that the benefit of it is
zero - or it is plain wrong in the kernel.
Lets try to focus on this.

	Sam
