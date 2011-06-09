Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1FILZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:25:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:26168 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab1FILZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:25:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,341,1304319600"; 
   d="scan'208";a="16078883"
Date: Thu, 9 Jun 2011 14:25:46 +0300
From: Heikki Krogerus <krohei@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH 0/3] Support for SUSPEND and RESUME for USB chargers
Message-ID: <20110609112546.GA23520@xps8300>
References: <1307526281-12125-1-git-send-email-krohei@gmail.com>
 <20110608205405.GB27448@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110608205405.GB27448@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 01:54:05PM -0700, Greg KH wrote:
> On Wed, Jun 08, 2011 at 12:44:38PM +0300, Heikki Krogerus wrote:
> > The charging should be prevented if the bus is suspended.
> > 
> > These notifications will come from the udc drivers. I'll create a
> > separate patch set for those, as I guess the maintainers of the
> > controller drivers need to approve those.
> 
> Can you send them here as well?  These patches never set this value, so
> I don't see why you did it this way, instead of just getting the
> "normal" suspend/resume callback and triggering off of that.

I'm not completely sure what you mean with "normal" suspend/resume
callback? I want to get the information about the SUSPEND and RESUME
bus states to the charger drivers and I don't want to tie them with
any USB transceiver or controller driver. Wasn't this the reason for
having the otg notifiers in the first place?

I'll spend a bit more time with these and resend when I have
everything ready. Gražvydas noticed an issue with the
isp1704_charger.c so that patch is broken in any case.

> Still confused,

I did not think this through. Sorry about that. I should have send
everything from the beginning and I should have been more clear what
I'm after with these.

-- 
heikki
