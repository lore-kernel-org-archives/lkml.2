Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1BQUHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:07:04 -0500
Received: from kroah.org ([198.145.64.141]:42710 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab1BQUHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:07:01 -0500
Date: Thu, 17 Feb 2011 12:06:32 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Rework tty helpers to avoid need for file
 pointers
Message-ID: <20110217200632.GA27228@kroah.com>
References: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 04:25:51PM +0000, Alan Cox wrote:
> (and then use this to fix the holes in hci_ath)
> 
> The cleanup wants doing anyway but we have a reason for needing to do it.

All now applied, including a build fix that you missed :)

thanks,

greg k-h
