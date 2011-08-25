Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1HYPrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:47:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48358 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab1HYPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:47:15 -0400
X-Sasl-enc: 1W0vAkEErbQ29tYFdwenUO4qrSn7EF0OvcSEFnbpd6Jn 1314287234
Date: Thu, 25 Aug 2011 08:47:05 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Henry Ptasinski <henryp@broadcom.com>, linux-kernel@vger.kernel.org,
        Brett Rudley <brudley@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        devel@linuxdriverproject.org, Greg KH <gregkh@suse.de>,
        Kan Yan <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: brcmfmac: Consolidate debugging macros
Message-ID: <20110825154705.GA6567@kroah.com>
References: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:16:48PM -0700, Joe Perches wrote:
> Convert multiple BRCMF_<debug_level> macros to a single
> brcmf_dbg(level, fmt, ...) macro.
> 
> Remove the now unnecessary double parentheses in the uses
> of the old macros when converting to brcmf_dbg.
> 
> Delete all uses of "%s: [fmt]", __func__, args... and move
> the "%s: ", __func__ to the macro for consistency.
> 
> Coalesce long formats.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

greg k-h
