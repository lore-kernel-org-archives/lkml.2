Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1E0TWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:22:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1E0TWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:22:42 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=kJ--3F4o5PMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=57SR5P8rsa_baP9B4koA:9 a=DnCIbga2C6X0tTHUMx8A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: anish <anish198519851985@gmail.com>, davej@redhat.com, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306521941.31864.19.camel@Joe-Laptop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
	 <1306520217.3857.31.camel@gandalf.stny.rr.com>
	 <1306521941.31864.19.camel@Joe-Laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 May 2011 15:22:40 -0400
Message-ID: <1306524160.3857.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 11:45 -0700, Joe Perches wrote:
> On Fri, 2011-05-27 at 14:16 -0400, Steven Rostedt wrote:
> > I once had my quilt mail send crap to LKML because one of the Cc's in a
> > patch I pulled was missing the ending ">".
> 
> I'm pretty sure I've done that using git-send-email
> via bad copy/paste.
> 
> Actually, that one's been done a few times.
> 
> $ git log --pretty=oneline -E -i --grep "-by:.*<[^>]+$" | wc -l
> 129
> 
> But that's out of 232816 non-merge commits.

Even so, it would have been nice, because I ended up sending a crap load
of emails to LKML without any content. I still use quilt as I like to
verify what I send. But it took a dump on the missing ">" and caused all
patches to be sent out as crap.

-- Steve


