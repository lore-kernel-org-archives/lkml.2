Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab1JCXqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:46:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab1JCXqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:46:31 -0400
Date: Mon, 3 Oct 2011 16:32:16 -0700
From: Greg KH <gregkh@suse.de>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG: kernel 3.0.4] Hard lockup / NULL pointer reference USB /
 BLOCK Layer
Message-ID: <20111003233216.GA30470@suse.de>
References: <4E89E374.8020804@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89E374.8020804@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 06:31:48PM +0200, Knut Petersen wrote:
> Hi everybody!
> 
> I connected two USB flash drives and tried to erase them using dd:
> 
> dd if=/dev/zero of=/dev/sdc bs=65536
> dd if=/dev/zero of=/dev/sdd bs=65536
> 
> I left the machine for some hours and found it completely locked
> on return. No reaction to the keybard, network access impossible.
> A hard reboot was necessary.
> 
> Attached find the relevant part of /var/log/messages and the configuration
> of the kernel used.

Can you please try 3.0.6 which is now out?  There is a USB/block layer
fix in it.

thanks,

greg k-h
