Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1H2SFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:05:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45805 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182Ab1H2SFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:05:49 -0400
X-Sasl-enc: XuLCzDP4RZjWp3L5evCAafWvPu1mcSQDOLQfH7FDi20M 1314641148
Date: Mon, 29 Aug 2011 11:05:11 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 37/46] Staging: hv: vmbus: Check for events before
 messages
Message-ID: <20110829180511.GA7167@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-37-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314469905-7058-37-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 11:31:36AM -0700, K. Y. Srinivasan wrote:
> Conform to Windows specification by checking for events before messages.

What specification?

Care to provide a comment in the code that you are doing this in this
explicit order because of some rule that the hypervisor imposes on us?

thanks,

greg k-h
