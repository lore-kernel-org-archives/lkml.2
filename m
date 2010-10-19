Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0JSPRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:17:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0JSPR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:17:29 -0400
Date: Tue, 19 Oct 2010 08:03:58 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Wakeup: Show wakeup sources statistics in debugfs
Message-ID: <20101019150358.GB10625@suse.de>
References: <201010180122.35382.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010180122.35382.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:22:35AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There may be wakeup sources that aren't associated with any devices
> and their statistics information won't be available from sysfs. Also,
> for debugging purposes it is convenient to have all of the wakeup
> sources statistics available from one place.  For these reasons,
> introduce new file "wakeup_sources" in debugfs containing those
> statistics.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
