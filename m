Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1LIXr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:47:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1LIXrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:47:51 -0500
Date: Fri, 9 Dec 2011 15:47:37 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/4] PM: Make the PM core execute driver callbacks if
 subsystem ones are not present
Message-ID: <20111209234737.GA6519@suse.de>
References: <201112100018.38536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112100018.38536.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 12:18:38AM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> The following patchset changes the PM core so that driver callbacks
> are executed automatically when subsystem ones are not present and
> uses the new PM core's behavior to simplify the platform and AMBA bus
> types (there probably are many more bus types that may be simplified
> this way, but those two were the easiest targets for me).
> 
> The reasons why to do this are outlined in the changelog of the second patch.
> 
> Comments welcome!

Looks sane to me, nice work.

greg k-h
