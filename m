Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0ICHcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:32:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58769 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0ICHcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:32:02 -0400
Date: Fri, 3 Sep 2010 08:31:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH 14/24] msm: add hotplug stub functions
Message-ID: <20100903073135.GD26319@n2100.arm.linux.org.uk>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org> <1282712273-344-15-git-send-email-johlstei@codeaurora.org> <20100902111157.GX26319@n2100.arm.linux.org.uk> <1283446177.3674.0.camel@c-dwalke-linux.qualcomm.com> <20100902171253.GX26319@n2100.arm.linux.org.uk> <1283467000.3674.381.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283467000.3674.381.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 03:36:40PM -0700, Daniel Walker wrote:
> If no others use it .. We can do this to fix them all. What do you
> think?

If no one else implements it, then you can't suspend, nor can you
support kexec.  (We should update Kconfig to add this as a dependency.)

So if you want these features, you'll need to implement hotplug CPU
support.
