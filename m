Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1AFUKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:10:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab1AFUKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:10:45 -0500
Date: Thu, 6 Jan 2011 12:10:38 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch for 2.6.37.1
Message-ID: <20110106201038.GA26803@suse.de>
References: <4D26200A.6040208@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D26200A.6040208@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 02:03:22PM -0600, Timur Tabi wrote:
> Greg,
> 
> What is the process for getting a patch into 2.6.37.1?  I posted this patch last
> month, hoping it would get into 2.6.37, but I was too late:
> 
> http://patchwork.ozlabs.org/patch/74171/
> 
> This patch will make it into 2.6.38.  I am hoping it will also go into 2.6.37.1,
> but I've never submitted a patch for a maintenance release of the kernel.

Please read the file, Documentation/stable_kernel_rules.txt for how to
get a patch into the stable kernel releases.

If you have any further questions after reading that, please let me
know.

thanks,

greg k-h
