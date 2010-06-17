Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491Ab0FQRbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:31:55 -0400
Received: from kroah.org ([198.145.64.141]:44230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab0FQRby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:31:54 -0400
Date: Thu, 17 Jun 2010 10:31:01 -0700
From: Greg KH <greg@kroah.com>
To: Dongdong Deng <dongdong.deng@windriver.com>
Cc: jason.wessel@windriver.com, gregkh@suse.de, galak@kernel.crashing.org,
       bruce.ashfield@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: cpm_uart: implement the cpm_uart_early_write()
 function for console poll
Message-ID: <20100617173101.GB24362@kroah.com>
References: <1276744420-7845-1-git-send-email-dongdong.deng@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276744420-7845-1-git-send-email-dongdong.deng@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 11:13:40AM +0800, Dongdong Deng wrote:
> The cpm_uart_early_write() function which was used for console poll
> isn't implemented in the cpm uart driver.
> 
> Implementing this function both fixes the build and allows
> kgdboc to work via the cpm uart.

So this is needed for the .35 release, right?  Any older kernel releases
as well?

thanks,

greg k-h
