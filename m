Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1BOQAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:00:50 -0500
Received: from kroah.org ([198.145.64.141]:59487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1BOQAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:00:48 -0500
Date: Tue, 15 Feb 2011 06:28:20 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Kacper Kornet <kornet@camk.edu.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [for .36, .37 stable] Re: [PATCH v2] Fix prlimit64
 for suid/sgid processes
Message-ID: <20110215142820.GA10597@kroah.com>
References: <20110127134710.GB519@camk.edu.pl>
 <AANLkTimOM7KDtFkU=CmXZ8J2FqekY=EjCuOdtZHQJQWT@mail.gmail.com>
 <20110128232104.GA22667@camk.edu.pl>
 <4D4683A9.8050400@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4683A9.8050400@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 10:40:57AM +0100, Jiri Slaby wrote:
> Ccing stable.
> 
> Merged as aa5bd67dcfdf9 and should go into:
> ->.36-stable (if maintained still)
> ->.37-stable

Thanks, now queued up.

greg k-h
