Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2CENWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:22:10 -0500
Received: from 1wt.eu ([62.212.114.60]:62859 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2CENWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:22:09 -0500
Date: Mon, 5 Mar 2012 14:18:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
Message-ID: <20120305131847.GH30594@1wt.eu>
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com> <4F54B618.1090301@suse.cz> <20120305131323.GB3627@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305131323.GB3627@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:13:23PM +0100, Heiko Carstens wrote:
> > I don't know, I haven't checked. It was just a shot in the dark. Maybe
> > it's easier to revert the removal of asm/compat.h from s390 files. Could
> > you bake a patch?
> 
> Sure:
> 
> From f88668aaee256a331ea03c852c672d3ef7704208 Mon Sep 17 00:00:00 2001
(...)

Patch queued, thanks Heiko !

Willy

