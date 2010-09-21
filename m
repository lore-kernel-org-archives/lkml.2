Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0IUE7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:59:24 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58692 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0IUE7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:59:23 -0400
Date: Tue, 21 Sep 2010 06:59:21 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, greg@kroah.com,
        stefanr@s5r6.in-berlin.de, broonie@opensource.wolfsonmicro.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] scripts/get_maintainer.pl: fix .mailmap handling
Message-ID: <20100921065921.03f06293@schatten.dmk.lab>
In-Reply-To: <1285028085.25988.60.camel@Joe-Laptop>
References: <1285021645-14311-1-git-send-email-florian@mickler.org>
	<1285022156-14501-1-git-send-email-florian@mickler.org>
	<1285028085.25988.60.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 17:14:45 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2010-09-21 at 00:35 +0200, florian@mickler.org wrote:
> > From: florian@mickler.org <florian@mickler.org>
> > diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> 
> []
> 
> > -	my ($name, $address) = parse_email($line);
> > -	$line = format_email($name, $address, $email_usename);
> > +	next if (/^\s*$/); #skip empty lines
> > +	#print "entry: \"$_\"\n";
> 
> Please do not add commented out debugging code.
> Add and use use some centralized debug(foo) call.

Hm. Yes that might be better in the long run. 

> 
> []
> 
> > +sub mailmap {
> > +    my (@addresses) = @_;
> > +
> > +    my @ret = ();
> 
> Suboptimal naming.  I try to use descriptive names.
> 
> cheers, Joe
> 

:-) 

Come on, Joe! It was "sub mailmap" before. @addresses was @list before
and @ret is the list that get's returned by the function. 

If you think a patch is ok, you actually may say so. 

Regards,
Flo
