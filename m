Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1FHUyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:54:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36485 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318Ab1FHUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:54:15 -0400
X-Sasl-enc: hih1YBMUBe/q9aJOD1/uids03F09Q6F8ImQyv0kKecte 1307566454
Date: Wed, 8 Jun 2011 13:54:05 -0700
From: Greg KH <greg@kroah.com>
To: Heikki Krogerus <krohei@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Support for SUSPEND and RESUME for USB chargers
Message-ID: <20110608205405.GB27448@kroah.com>
References: <1307526281-12125-1-git-send-email-krohei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307526281-12125-1-git-send-email-krohei@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 12:44:38PM +0300, Heikki Krogerus wrote:
> Hi,
> 
> The charging should be prevented if the bus is suspended.
> 
> These notifications will come from the udc drivers. I'll create a
> separate patch set for those, as I guess the maintainers of the
> controller drivers need to approve those.

Can you send them here as well?  These patches never set this value, so
I don't see why you did it this way, instead of just getting the
"normal" suspend/resume callback and triggering off of that.

Still confused,

greg k-h
