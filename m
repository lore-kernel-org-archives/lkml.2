Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1L3PiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 10:38:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1L3PiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 10:38:12 -0500
Date: Fri, 30 Dec 2011 10:37:41 -0500
From: Dave Jones <davej@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Sam Ravnborg <sam@ravnborg.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: add target to install gzipped modules
Message-ID: <20111230153741.GA2167@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michal Marek <mmarek@suse.cz>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Sam Ravnborg <sam@ravnborg.org>, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
 <20111229172101.GB4101@redhat.com>
 <4EFD913E.7010707@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFD913E.7010707@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 11:23:58AM +0100, Michal Marek wrote:
 > On 29.12.2011 18:21, Dave Jones wrote:
 > > On Thu, Dec 29, 2011 at 01:50:18PM -0200, Lucas De Marchi wrote:
 > >  > Add target in Makefile to compress the module after it's installed.
 > >  > Module-init-tools and libkmod can handle gzipped modules.
 > >  > 
 > >  > This is not much useful for distributions because the package will gzip
 > >  > the modules and call depmod in a install rule. 
 > > 
 > > It might actually be a worthwhile thing for distributions.
 > > 
 > > For a Fedora kernel, gzipping modules saves around 80MB of diskspace per
 > > installed kernel.  That the RPM is compressed is irrelevant, the on-disk
 > > footprint is more interesting, given that the bulk of the modules installed
 > > will never even be loaded.
 > 
 > But it kills performance of the tools.

How often do you run depmod ?

If modprobe is a bottleneck, you have other problems.

	Dave

