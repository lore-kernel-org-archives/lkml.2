Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab2BJOa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab2BJOa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:30:56 -0500
Date: Fri, 10 Feb 2012 12:30:49 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf tools: More fixes and updates
Message-ID: <20120210143049.GD4998@infradead.org>
References: <1323966762-8574-1-git-send-email-robert.richter@amd.com> <20120131155154.GH16322@erda.amd.com> <20120202201402.GG8566@infradead.org> <20120210113140.GL16322@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210113140.GL16322@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 10, 2012 at 12:31:40PM +0100, Robert Richter escreveu:
> On 02.02.12 18:14:02, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Jan 31, 2012 at 04:51:54PM +0100, Robert Richter escreveu:
> > > On 15.12.11 17:32:38, Robert Richter wrote:
> > > > Some more fixes and updates for perf tools.

> > > > Robert Richter (4):
> 
> > > >   perf tools: Moving code in header.c
> > > >   perf tools: Factor out feature op to process header sections

> > Agreed, I applied both to my local repo, after some testing and
> > reviewing some more patches I'll push it to Ingo, thanks,

> Arnaldo, the two above are not yet applied. Should I drop them?

IIRC they didn't applied, can you check that are resubmit?

Thanks,

- Arnaldo
