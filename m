Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110Ab1JFHRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:17:04 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:33751 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab1JFHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:17:03 -0400
Date: Thu, 6 Oct 2011 10:16:57 +0300
From: Adrian Bunk <bunk@stusta.de>
To: "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, Valdis.Kletnieks@vt.edu,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111006071656.GA25753@localhost.pp.htv.fi>
References: <34045.1317760188@turing-police.cc.vt.edu>
 <20111004223932.GA3460@localhost.pp.htv.fi>
 <20111004231730.GB17089@redhat.com>
 <20111005075438.GA29441@localhost.pp.htv.fi>
 <20111005170616.GD4297@thunk.org>
 <20111005192349.GA14406@localhost.pp.htv.fi>
 <20111005195024.GB14406@localhost.pp.htv.fi>
 <20111005200944.GB12876@suse.de>
 <20111005212526.GD14406@localhost.pp.htv.fi>
 <20111005234716.GD26361@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111005234716.GD26361@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 07:47:16PM -0400, Ted Ts'o wrote:
> On Thu, Oct 06, 2011 at 12:25:26AM +0300, Adrian Bunk wrote:
> > 
> > Had debsums told me that /bin/bash was modified I would have been quite 
> > convinced.
> 
> Keep in mind that debsums is trivially easy to circument.  That just
> checks against an md5 checksum stored in a text file in
> /var/lib/dpkg/info/*.md5sums.  If someone modified /bin/bash it would
> easy enough for them to modify the relevant md5sums file.

I am not so naïve to assume there was any way to prove my machine is not 
compromised.

My first assumption is that my machine is not compromised, and also
that the latest e2fsprogs you uploaded to Debian unstable and that
I installed on my machine does not contain a trojan added by someone
who hijacked your machine or your key.

There is no 100% security, only compromises between security and costs.

>      	    	     	       	   	    - Ted

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

