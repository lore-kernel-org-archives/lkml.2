Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1GEQPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:15:12 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37346 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab1GEQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:15:08 -0400
X-Sasl-enc: FdqAbubg0t+dVoqjS7BetGxvVD0er8uhE9p6UptVQlvc 1309882507
Date: Tue, 5 Jul 2011 09:14:08 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 01/40] Staging: hv: storvsc: Do not aquire an unnecessary
 reference on stor_device
Message-ID: <20110705161408.GA25532@kroah.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 07:38:58AM -0700, K. Y. Srinivasan wrote:
> On entry into storvsc_on_io_completion() we have already acquired a reference
> on the stor_device; there is no need to acquire an additional reference here.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

This series doesn't apply anymore, care to redo it?

thanks,

greg k-h
