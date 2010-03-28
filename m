Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0C1FBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 01:01:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:48905 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0C1FBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 01:01:51 -0400
Date: Sat, 27 Mar 2010 21:58:23 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: marcel@holtmann.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
Subject: Re: [v4] New ldisc for WiLink7.0
Message-ID: <20100328045823.GA10136@suse.de>
References: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 06:20:15PM -0500, pavan_savoy@ti.com wrote:
> 
> Greg / Alan,
> 
> 
> - moved to staging and completely self-contained
> - REMOVed the sysfs entry creation at root and replaced it with
> sending events via rfkill.
> - verified and working with new logic
> - patch re-ordered

Looks good, I'll go over them in more detail next week when I get a
solid internet connection and let you know if I can queue them up in my
tree or not.

thanks,

greg k-h
