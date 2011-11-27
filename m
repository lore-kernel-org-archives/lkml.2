Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab1K0J1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:27:12 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60889 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab1K0J1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:27:09 -0500
X-Sasl-enc: V7xk47m8sWFf6goZ/owvkQ77JzerxoMiHzhFuLuhTUAf 1322386026
Date: Sat, 26 Nov 2011 17:00:59 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Remove the mouse driver from
 the staging tree
Message-ID: <20111127010059.GA19285@kroah.com>
References: <1322285308-3507-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322285308-3507-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 09:28:28PM -0800, K. Y. Srinivasan wrote:
> The mouse driver for Hyper-V is a HID compliant mouse driver.
> Now that all relevant review comments have been addressed,
> Jiri has agreed to merge this mouse driver into 3.3 hid.git.
> This patch takes care of removing the mouse driver from the
> staging area. Greg, if you can ack this patch, Jiri will proceed
> with his merge.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Nice job.

greg k-h
