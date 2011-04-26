Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab1DZWra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:47:30 -0400
Received: from kroah.org ([198.145.64.141]:36294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007Ab1DZWpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:45:51 -0400
Date: Tue, 26 Apr 2011 15:45:45 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Message-ID: <20110426224545.GC31974@kroah.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303834842-5022-8-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:20:25AM -0700, K. Y. Srinivasan wrote:
> The vmbus driver cannot be unloaded; the windows host does not
> permit this. Cleanup accordingly.

Woah, you just prevented this driver from ever being able to be
unloaded.

That's not a "cleanup" that's a major change in how things work.  I'm
sure, if you want to continue down this line, there are more things you
can remove from the code, right?

What is the real issue here?  What happens if you unload the bus?  What
goes wrong?  Can it be fixed?

This is a pretty big commitment...

thanks,

greg k-h
