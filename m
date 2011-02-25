Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1BYDkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 22:40:02 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1BYDkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 22:40:00 -0500
Date: Fri, 25 Feb 2011 03:39:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Kees Cook <kees.cook@canonical.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110225033945.GF22723@ZenIV.linux.org.uk>
References: <20110222193418.773ccd4b@lxorguk.ukuu.org.uk>
 <20110222195018.GA4000@outflux.net>
 <20110222201610.GA29787@suse.de>
 <20110222202856.GE4000@outflux.net>
 <20110222203704.GA7224@suse.de>
 <20110222205413.GH4000@outflux.net>
 <20110225002214.GW4212@outflux.net>
 <20110225003508.GB27272@suse.de>
 <20110225011242.GY4212@outflux.net>
 <20110225033146.GA8526@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225033146.GA8526@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 07:31:46PM -0800, Greg KH wrote:
> On Thu, Feb 24, 2011 at 05:12:42PM -0800, Kees Cook wrote:
> > On Thu, Feb 24, 2011 at 04:35:08PM -0800, Greg KH wrote:
> > > On Thu, Feb 24, 2011 at 04:22:14PM -0800, Kees Cook wrote:
> > > > On Tue, Feb 22, 2011 at 12:54:13PM -0800, Kees Cook wrote:
> > > > > On Tue, Feb 22, 2011 at 12:37:04PM -0800, Greg KH wrote:
> > > > > > On Tue, Feb 22, 2011 at 12:28:56PM -0800, Kees Cook wrote:
> > > > > > > On Tue, Feb 22, 2011 at 12:16:10PM -0800, Greg KH wrote:
> > > > > > > > On Tue, Feb 22, 2011 at 11:50:18AM -0800, Kees Cook wrote:
> > > > > > > > > On Tue, Feb 22, 2011 at 07:34:18PM +0000, Alan Cox wrote:
> > > > > > > > > > > What system do you proposed to keep these "stupid mistakes" from

Gentlement, I must congratulate you on the perfect match of form and contents,
but could you please take that to the place where it belongs?  alt.cascade
is -> that way...
