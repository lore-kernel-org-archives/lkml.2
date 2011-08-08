Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1HHU5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:57:15 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35710 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953Ab1HHU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:57:14 -0400
X-Sasl-enc: TRYY9EKskT8xtjP4mA2cZA52Jlsrjbnkh0u4xoepqNxM 1312837032
Date: Mon, 8 Aug 2011 13:56:31 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] n_gsm: generate gsmtty device nodes
Message-ID: <20110808205631.GA26202@kroah.com>
References: <20110726132716.27387.21457.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726132716.27387.21457.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 02:27:50PM +0100, Alan Cox wrote:
> (Seems this one got lost somewhere but it is still relevant)
> 
> From: Ken Mills <ken.k.mills@intel.com>
> 
> The mux does not generate gsmtty device nodes in /dev.
> 
> Added call to tty_register_device in function gsmld_attach_gsm to do this.
> 
> Signed-off-by: Ken Mills <ken.k.mills@intel.com>
> [Rewrote to work with multiple muxes]
> Signed-off-by: Alan Cox <alan@linux.intel.com>

It doesn't apply to 3.1-rc1 though, care to refresh it and resend?

thanks,

greg k-h
