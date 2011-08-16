Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1HPQvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:51:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1HPQvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:51:48 -0400
Date: Tue, 16 Aug 2011 09:50:16 -0700
From: Greg KH <gregkh@suse.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        rpearson@systemfabricworks.com
Subject: Re: [PATCH] docs/kobject: Explain device.groups
Message-ID: <20110816165016.GA21641@suse.de>
References: <201108161844.07095.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108161844.07095.bvanassche@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 06:44:06PM +0200, Bart Van Assche wrote:
> Many drivers use device_create_file() where device.groups should be
> used instead. Since this has not yet been documented, add a note in
> Documentation/kobject.txt that explains why device.groups should be
> used.

That's a nice goal, but kobject.txt is now about the driver model
interfaces.  Care to put that in the driver model documentation instead?

thanks,

greg k-h
