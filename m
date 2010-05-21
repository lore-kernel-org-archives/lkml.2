Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0EUUNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 16:13:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab0EUUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 16:13:12 -0400
Date: Fri, 21 May 2010 13:13:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Mickler <florian@mickler.org>
Cc: Joe Perches <joe@perches.com>, Stephen Hemminger <shemminger@vyatta.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: improve config-file support
Message-Id: <20100521131303.ad40e6d8.akpm@linux-foundation.org>
In-Reply-To: <20100520084615.6e2efa38@schatten.dmk.lab>
References: <1273698720-4010-1-git-send-email-florian@mickler.org>
	<1273703333.20514.392.camel@Joe-Laptop.home>
	<20100513095652.34aea727@schatten.dmk.lab>
	<20100520084615.6e2efa38@schatten.dmk.lab>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 08:46:15 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Thu, 13 May 2010 09:56:52 +0200
> Florian Mickler <florian@mickler.org> wrote:
> 
> > On Wed, 12 May 2010 15:28:53 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > On Wed, 2010-05-12 at 23:12 +0200, florian@mickler.org wrote:
> > > > This changes the syntax of the config-file introduced in the commit
> > > > "scripts/get_maintainer.pl: add .get_maintainer.conf default options
> > > > file".
> > > > Entries are now of the more commonly found form:
> > > > 	key = value
> > > > where keys are cmd-line arguments without the "--" prefixed.
> > > 
> > > I don't have a strong opinion one way or another about the
> > > .conf file format.
> > > 
> > > Another option which could be useful:  --noconf, don't read the file.
> > > 
> > > > as well as warn if unrecognized options are
> > > > specified.
> > > 
> > > The old approach does that as well.
> > 
> > True.
> > 
> > > 
> > > > +if (!GetOptions( \%prefs,
> > > 
> > > I think you don't need to repeat the options.
> > > Doesn't this work?
> > > 	if (!GetOptions(\%prefs)) {
> > > 	    die "$P: invalid argument - use --help if necessary\n";
> > > 
> > No, GetOpts::Long needs a special markup for parsing the cmdline
> > string, like =s for specifying that that option is accompanied by a
> > string value or the ! for specifying that it is a flag. 
> > Also there are aliases defined for config-options.
> > 
>
> Hi Andrew!
> 
> What's the status of this patch?
> Do you take it, or do you have an issue with it? This is a clear
> improvement in my opinion.
> 

(top-posting repaired)

Joe didn't sound very excited about it.

If we're going to do this, we should hurry up, please - it'd be silly
to introduce a config file and then change its format shortly
afterwards.

