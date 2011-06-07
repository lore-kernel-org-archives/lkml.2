Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1FGUtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:49:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48812 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab1FGUtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:49:10 -0400
X-Sasl-enc: MDmzck4EpJhNHW4kFs4LfGknnP/4iYXsVmdWEPFSLE8w 1307479749
Date: Tue, 7 Jun 2011 13:45:14 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 49/49] Staging: hv: vmbus: Increase the timeout value in
 vmbus_request_offers()
Message-ID: <20110607204514.GB16429@kroah.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-49-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307400613-13234-49-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 03:50:13PM -0700, K. Y. Srinivasan wrote:
> Increase the timeout value in vmbus_request_offers().

Why?  What does this solve/fix/prevent?

thanks,

greg k-h
