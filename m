Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2KCXKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 19:10:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2KCXKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 19:10:07 -0400
Date: Sun, 4 Nov 2012 00:09:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Chris Friesen <chris.friesen@genband.com>, Pavel Machek <pavel@ucw.cz>,
        Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <20121102154833.GG3300@redhat.com>
Message-ID: <alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz>
References: <50919EED.3020601@genband.com> <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz> <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz> <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com> <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com> <20121101202701.GB20817@xo-6d-61-c0.localdomain> <5092E361.7080901@genband.com>
 <20121102154833.GG3300@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Vivek Goyal wrote:

> > With secure boot enabled, then the kernel should refuse to let an
> > unsigned kexec load new images, and kexec itself should refuse to
> > load unsigned images.
> 
> Yep, good in theory. Now that basically means reimplementing kexec-tools
> in kernel. 

Why is "when kernel has been securely booted, the in-kernel kexec 
mechanism has to verify the signature of the supplied image before 
kexecing it" not enough? (basically the same thing we are doing for signed 
modules already).

-- 
Jiri Kosina
SUSE Labs
