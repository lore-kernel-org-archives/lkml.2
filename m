Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0EGKvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:51:10 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50536 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab0EGKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:51:08 -0400
Date: Fri, 7 May 2010 12:50:59 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: ath5k deadlock w/ blob transfer
Message-ID: <20100507105059.GE3479@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Guess, this is better suited in here:

>   - ath5k: when starting a blob transfer eg. ssh summer.jpg to the
>     notebook with the ath5k driver running, the wNIC freezes almost
>     immediately! Dead device. This is unfortunately too easily reproducible.
>     In fact, this is a blocker, wireless blob transfer via ssh (other means
>     not tested) is not possible w/o locking it up.

But wait! I just remembered another case. Using the (incomprehensibly) "obsolete"
madwifi diver (note aside: this driver _does_ reduce the _felt_ deadlock frequency 
or kernel panics, referenced by http://lkml.org/lkml/2010/5/3/229, but not 
entirely make them go away). It evenly locks the wireless NIC while transferring
blobs. 

So where should I be posting this? When both drivers deadlock it's either a common 
base in the wireless driver premisses or yet up the path somewhere in the kernel code.

Ideas?


  Thanks,

    Nils

