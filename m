Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935254Ab1ETE76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:59:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33637 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935136Ab1ETE74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:59:56 -0400
X-Sasl-enc: Xxg3W8vRYudZjxX9E7HwAjO+/4E/115m8sP87Hf8wwsW 1305867595
Date: Thu, 19 May 2011 22:01:01 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfm@muteddisk.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 01/12] staging: usbip: replace usbip_u{dbg,err,info} and
 printk with dev_ and pr_
Message-ID: <20110520050101.GA7461@kroah.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
 <2ecbb21cffe73acfe291c3c8e5626427ed5c5b43.1305866084.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ecbb21cffe73acfe291c3c8e5626427ed5c5b43.1305866084.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 09:36:55PM -0700, matt mooney wrote:
> This switches all of the usbip_u{dbg,err,info} and printk statements to
> dev_<level>, if possible, or pr_<level> macros. And removes a few
> unnecessary debug statements.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>

I've already applied this one, right?

greg k-h
