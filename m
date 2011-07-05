Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1GEUKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:10:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:38430 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1GEUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:10:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Re: Kernel panic with USB device
Date: Tue, 05 Jul 2011 22:09:51 +0200
Message-ID: <iuvr27$t97$1@dough.gmane.org>
References: <iumfu8$jmf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 0x4dd52733.adsl.cybercity.dk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 09:04, Niels wrote:

> Hi, I've written about this before and it just happened again:
> 
> I have an AGK hard disk docking station, like this:
> 
> http://www.agknordic.com/index.php?side_id=387
> 
> Kernel is 2.6.38-gentoo-r6.
> 
> The problem is that on rare occasions, the machine crashes when I power
> the device on. Like right now, Num lock and Caps lock blinking. There's
> nothing in the log, other that a couple of lines of ^@. The machine didn't
> respond to external ssh or pings.
> 
> From now on, I'll try turning it on and then connecting its USB.
> 

I put "noauto" in fstab, to assure that there's no mounting done. Still, it
just happened again.


Niels

