Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1E0Tdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:33:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2155 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab1E0Tdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:33:47 -0400
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: anish <anish198519851985@gmail.com>, davej@redhat.com, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306524160.3857.34.camel@gandalf.stny.rr.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
	 <1306520217.3857.31.camel@gandalf.stny.rr.com>
	 <1306521941.31864.19.camel@Joe-Laptop>
	 <1306524160.3857.34.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 12:33:45 -0700
Message-ID: <1306524825.31864.51.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 15:22 -0400, Steven Rostedt wrote:
> On Fri, 2011-05-27 at 11:45 -0700, Joe Perches wrote:
> > On Fri, 2011-05-27 at 14:16 -0400, Steven Rostedt wrote:
> > > I once had my quilt mail send crap to LKML because one of the Cc's in a
> > > patch I pulled was missing the ending ">".
> > $ git log --pretty=oneline -E -i --grep "-by:.*<[^>]+$" | wc -l
> > 129
> > But that's out of 232816 non-merge commits.
> Even so, it would have been nice, because I ended up sending a crap load
> of emails to LKML without any content. I still use quilt as I like to
> verify what I send. But it took a dump on the missing ">" and caused all
> patches to be sent out as crap.

No doubt.

This concept should also verify the "To: " and "cc: " tag lines.

cheers, Joe

