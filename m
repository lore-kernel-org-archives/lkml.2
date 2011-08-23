Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1HWBdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 21:33:08 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37865 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362Ab1HWBdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 21:33:06 -0400
X-Sasl-enc: tb4WXsW9hRKnhY0rtsnO7lxopi5hVkXuxQoeGHYiCVPN 1314063185
Date: Mon, 22 Aug 2011 18:32:24 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/11] various fixes v3
Message-ID: <20110823013224.GA7190@kroah.com>
References: <cover.1313085588.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1313085588.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:36:17PM -0400, Jason Baron wrote:
> Hi,
> 
> Dynamic debug fixes and cleanups. Only changes from v2 are a re-base against
> Linus's latest tree and the inclusion of the re-posted version for patch #11.

I applied the first 8, as it seemed like there was lots of discussion
about #9.

Care to send the rest when you all have those worked out?

thanks,


greg k-h
