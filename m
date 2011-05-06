Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1EFX5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 19:57:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:50071 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab1EFX5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 19:57:07 -0400
Date: Fri, 6 May 2011 16:53:44 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Wakeup: Fix build warning related to the "wakeup"
 sysfs file
Message-ID: <20110506235344.GA22803@suse.de>
References: <201105070050.55235.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105070050.55235.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 12:50:55AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The "wakeup" device sysfs file is only created if CONFIG_PM_SLEEP
> is set, so put it under CONFIG_PM_SLEEP and make a build warning
> related to it go away.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
