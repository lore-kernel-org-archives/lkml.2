Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1IPSX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:23:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab1IPSXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:23:55 -0400
Date: Fri, 16 Sep 2011 20:23:50 +0200
From: Greg KH <gregkh@suse.de>
To: Josh Boyer <jwboyer@redhat.com>
Cc: andi@firstfloor.org, willy@meta-x.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: stable patch queues and submission
Message-ID: <20110916182350.GA7315@suse.de>
References: <20110916181307.GW10700@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916181307.GW10700@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi All,
> 
> With kernel.org being down, the stable@kernel.org list is no longer
> working.  This leaves me wondering if we should send patches directly to
> the various stable tree maintainers with [stable] in the prefix and
> linux-kernel CC'd, or if the stable queues are even being maintained
> during the outage.

No, please do not, unless you need something "special", and even then,
please cc: lkml and the developers so it's not lost.

> Does anyone have a preference or suggestion on how to continue stable
> releases until the list comes back?  (I'm assuming 'wait' isn't really a
> best all around option.)

Wait and continue to add the marking to your patches, my scripts are
still running and pulling the patches out and they are going into the
stable queue just fine.  The queue just isn't public at the moment due
to kernel.org being out.

greg k-h
