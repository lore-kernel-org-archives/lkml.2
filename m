Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0LLTCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:02:08 -0500
Received: from kroah.org ([198.145.64.141]:34870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab0LLTCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:02:07 -0500
Date: Sun, 12 Dec 2010 10:48:34 -0800
From: Greg KH <greg@kroah.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: Re: [PATCH -mm 4/4] RapidIO: Add new sysfs attributes
Message-ID: <20101212184834.GA17052@kroah.com>
References: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
 <1292013498-31406-5-git-send-email-alexandre.bounine@idt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292013498-31406-5-git-send-email-alexandre.bounine@idt.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 03:38:18PM -0500, Alexandre Bounine wrote:
> Add new sysfs attributes.

Like Andrew pointed out, all sysfs files are required to have entries in
Documentation/ABI.  If the existing rapidio sysfs files are not
documented, please document them in there _before_ adding new ones.

thanks,

greg k-h
