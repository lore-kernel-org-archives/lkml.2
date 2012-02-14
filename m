Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2BNXPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:15:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab2BNXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:15:00 -0500
Date: Tue, 14 Feb 2012 18:14:51 -0500
From: Dave Jones <davej@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Kerneloops.org defunct?
Message-ID: <20120214231450.GB13981@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Bastien ROUCARIES <roucaries.bastien@gmail.com>,
	Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
	Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>
References: <4DE6264A.2040901@gmail.com>
 <CAKA=qzbHnqiz=CuxM1n55EDnvQpqMw42eY8FuLJrGPYN3KWgVA@mail.gmail.com>
 <CAE2SPAYuYTYj9ukDzitKs+d2uKZacJ5eFo7N+-p9pWgf1MWW2w@mail.gmail.com>
 <201112211325.53648.roucaries.bastien@gmail.com>
 <CAE2SPAbYQnoc8CGzQizFq6tCvuks57z2tLCwTjPLhxmViJeBLw@mail.gmail.com>
 <CAE2SPAbx3hJfn_fMU24sEfg6_UFXmRrk1AGznkHZN7YTNiGwCQ@mail.gmail.com>
 <CAE2SPAYN1fmQG05GhOVhwBSBqWyXfVxZw2iEbC=YXoegTpkKCA@mail.gmail.com>
 <4F3AD5F5.7010402@linux.intel.com>
 <20120214215450.GA22014@one.firstfloor.org>
 <20120214221240.GC11382@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214221240.GC11382@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 05:12:40PM -0500, Ted Ts'o wrote:
 > On Tue, Feb 14, 2012 at 10:54:50PM +0100, Andi Kleen wrote:
 > > On Tue, Feb 14, 2012 at 01:45:25PM -0800, Arjan van de Ven wrote:
 > > > On 2/14/2012 10:17 AM, Bastien ROUCARIES wrote:
 > > > > ping**5
 > > > > 
 > > > so.. with Fedora not really submitting oopses anymore, and the box
 > > > wiped/down from kernel.org...  what's the point still ??
 > > 
 > > Just scanning the mailing lists would be good.
 > > 
 > > But I assume Fedora may be willing to fix their submission?
 > 
 > I hear Fedora just got a new project leader; maybe it's time to
 > approach them again?

$ yum info libreport-plugin-kerneloops
Loaded plugins: fastestmirror, langpacks, presto, refresh-packagekit
Loading mirror speeds from cached hostfile
 * fedora: ftp.cse.buffalo.edu
 * rpmfusion-free: mirror.hiwaay.net
 * rpmfusion-free-updates: mirror.hiwaay.net
 * rpmfusion-nonfree: mirror.hiwaay.net
 * rpmfusion-nonfree-updates: mirror.hiwaay.net
 * updates: mirror.steadfast.net
 * updates-testing: mirror.steadfast.net
Installed Packages
Name        : libreport-plugin-kerneloops
Arch        : x86_64
Version     : 2.0.8
Release     : 4.fc16
Size        : 15 k
Repo        : installed
>From repo   : updates
Summary     : libreport's kerneloops reporter plugin
URL         : https://fedorahosted.org/abrt/
License     : GPLv2+
Description : This package contains plugin which sends kernel crash information to specified
            : server, usually to kerneloops.org.


 
