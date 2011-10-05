Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589Ab1JEXri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 19:47:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47764 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935554Ab1JEXrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 19:47:37 -0400
Date: Wed, 5 Oct 2011 19:47:16 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <gregkh@suse.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        Valdis.Kletnieks@vt.edu, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111005234716.GD26361@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Adrian Bunk <bunk@stusta.de>,
	Greg KH <gregkh@suse.de>, "Frank Ch. Eigler" <fche@redhat.com>,
	Valdis.Kletnieks@vt.edu, "H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20111003180441.GD3072@localhost.pp.htv.fi>
 <34045.1317760188@turing-police.cc.vt.edu>
 <20111004223932.GA3460@localhost.pp.htv.fi>
 <20111004231730.GB17089@redhat.com>
 <20111005075438.GA29441@localhost.pp.htv.fi>
 <20111005170616.GD4297@thunk.org>
 <20111005192349.GA14406@localhost.pp.htv.fi>
 <20111005195024.GB14406@localhost.pp.htv.fi>
 <20111005200944.GB12876@suse.de>
 <20111005212526.GD14406@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005212526.GD14406@localhost.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:25:26AM +0300, Adrian Bunk wrote:
> 
> Had debsums told me that /bin/bash was modified I would have been quite 
> convinced.
> 

Keep in mind that debsums is trivially easy to circument.  That just
checks against an md5 checksum stored in a text file in
/var/lib/dpkg/info/*.md5sums.  If someone modified /bin/bash it would
easy enough for them to modify the relevant md5sums file.

     	    	     	       	   	    - Ted
