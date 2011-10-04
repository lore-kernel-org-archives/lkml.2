Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab1JDR1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:27:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab1JDR1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:27:36 -0400
Date: Tue, 4 Oct 2011 09:52:03 -0700
From: Greg KH <gregkh@suse.de>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG: kernel 3.0.4] Hard lockup / NULL pointer reference USB /
 BLOCK Layer
Message-ID: <20111004165203.GD786@suse.de>
References: <4E89E374.8020804@t-online.de>
 <20111003233216.GA30470@suse.de>
 <4E8AE0BC.70203@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8AE0BC.70203@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 12:32:28PM +0200, Knut Petersen wrote:
> Both 3.0.4 and 3.0.6 were two times able to write to the flash drive that still identifies
> itself as a flash drive without problems with dd if=/dev/zero of=/dev/sda bs=65536.
> 
> Conclusion: Either there is/was a problem with massive parallel writes to at least two
> usb (flash) drives, or there is a problem with one of the flash drives itself.

I would place the blame here on the hardware, most usb flash drives can
not handle high rates of data, especially in parallel :(

> Any idea how to make a flash drive from that "memory bar"?

I have no idea, sorry.

greg k-h
