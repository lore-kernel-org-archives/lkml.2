Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948Ab1IIUrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:47:22 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33046 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759927Ab1IIUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:06 -0400
X-Sasl-enc: mXRJIcwjYzKb67v/ynQhnWeMujWL5EUuGkcTpQeq59eZ 1315601225
Date: Fri, 9 Sep 2011 13:32:28 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Integrate the time source driver with
 Hyper-V detection code
Message-ID: <20110909203228.GA19127@kroah.com>
References: <1315434310-4827-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315434310-4827-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 03:25:10PM -0700, K. Y. Srinivasan wrote:
> The Hyper-V timesource driver is best integrated with Hyper-V detection code
> since: (a) Linux guests running on Hyper-V need this timesource and (b)
> by integrating with Hyper-V detection, we could significantly  minimize the
> code in the timesource driver.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

