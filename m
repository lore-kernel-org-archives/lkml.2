Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1CKRNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:13:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:36836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab1CKRM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:12:59 -0500
Date: Fri, 11 Mar 2011 09:12:31 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [RFC][PATCH 2/2] Convert several sysdev users to using struct
 syscore_ops
Message-ID: <20110311171231.GB10437@suse.de>
References: <201103100131.58206.rjw@sisk.pl>
 <201103100134.02675.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103100134.02675.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 01:34:02AM +0100, Rafael J. Wysocki wrote:
> Some subsystems need to carry out suspend/resume and shutdown
> operations with one CPU on-line and interrupts disabled and they
> define sysdev classes and sysdevs specifically for this purpose.
> This leads to unnecessarily complicated code and excessive memory
> usage, so switch them to using struct syscore_ops objects for this
> purpose instead.

Heavily-Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

:)

Do you want to resend this with a signed-off-by and your first one so I
can apply it to my tree, or do you want to take it through yours?

thanks again for doing this.

greg k-h
