Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1LUVWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:22:00 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37764 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666Ab1LUVV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:21:56 -0500
X-Sasl-enc: L4D4CqGJ3uFBeoPZf2QOh+BiWr0rM7Im+j9Y+X3Xu/RI 1324502156
Date: Wed, 21 Dec 2011 13:12:51 -0800
From: Greg KH <greg@kroah.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linaro-dev@lists.linaro.org, patches@linaro.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ohci-hcd: ohci-hcd: use usleep_range() instead of
 mdelay()
Message-ID: <20111221211251.GB15627@kroah.com>
References: <4EF185AA.2000006@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF185AA.2000006@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:07:22AM +0400, Dmitry Antipov wrote:
> From ac60fe289eef3d81009f2b14a12acbac3e71878b Mon Sep 17 00:00:00 2001
> From: Dmitry Antipov <dmitry.antipov@linaro.org>
> Date: Wed, 21 Dec 2011 11:05:27 +0400
> Subject: [PATCH] ohci-hcd: use usleep_range() instead of mdelay()
> 

You didn't sign off on this, and you failed to explain why this is
needed.

You also didn't use git-send-email, making it a pain to apply (why do I
need the duplicate headers in the email body?

So consider this patch totally ignored.

greg k-h


