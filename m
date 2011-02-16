Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1BPPRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:17:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1BPPRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:17:38 -0500
Date: Wed, 16 Feb 2011 07:18:29 -0800
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dtor@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH] workqueue, freezer: unify spelling of 'freeze' +
 'able' to 'freezable'
Message-ID: <20110216151829.GC3550@suse.de>
References: <20110216083442.GB19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216083442.GB19830@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:34:42AM +0100, Tejun Heo wrote:
> There are two spellings in use for 'freeze' + 'able' - 'freezable' and
> 'freezeable'.  The former is the more prominent one.  The latter is
> mostly used by workqueue and in a few other odd places.  Unify the
> spelling to 'freezable'.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

