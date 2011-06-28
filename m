Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1F1V04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:26:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34233 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751590Ab1F1V0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:26:40 -0400
X-Sasl-enc: ZdLkQhxdP3C2+H+j7G/F+/zd9DV2b2PofbR0daoTwuup 1309296399
Date: Tue, 28 Jun 2011 14:20:16 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/29] gma500: revamp frame buffer creation and handling
Message-ID: <20110628212016.GA26600@kroah.com>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
 <20110616160756.6039.69998.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616160756.6039.69998.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 05:08:00PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> Restructure this to work the same way as the i915 frame buffer does. That
> cleans up various chunks of code.
> 
> We can now set a mode in modetest but mode restore is a bit iffy
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

As other patches didn't apply, I'll have to stop here in the series :(
