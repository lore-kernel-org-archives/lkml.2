Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab2JCXXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:23:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54661 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350Ab2JCXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:23:13 -0400
X-Sasl-enc: iv0D1WZEDD/tGPHc6sWb0D7KcMUzYtmsM8YSjVCEm92b 1349306592
Date: Wed, 3 Oct 2012 16:23:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: const@MakeLinux.com
Cc: nsekhar@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@ti.com, balbi@ti.com,
        miguel.aguilar@ridgerun.com, kernel-mentors@selenic.com
Subject: Re: [PATCH v3] Enable USB peripheral on dm365 EVM
Message-ID: <20121003232311.GA14392@kroah.com>
References: <1349301859-31306-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349301859-31306-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:04:19AM +0200, const@MakeLinux.com wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> From: Miguel Aguilar <miguel.aguilar@ridgerun.com>
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
> Tested with usb gadget g_zero.
> This patch is based on code from Arago, Angstom, and RidgeRun projects.
> Original patch is three years ago:
> http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14741.html

You can't have two "From:" lines.

And put the information above, in the changelog entry.

Also, it looks like you are modifying printk lines for no reason, why do
that in this patch?  That shouldn't be needed, right?

greg k-h
