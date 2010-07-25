Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0GYQLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 12:11:19 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50030 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0GYQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:11:18 -0400
Date: Sun, 25 Jul 2010 18:06:41 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: cryptsetup + lvm on usb disk, unusable /dev/dm-* after
 suspend/resume cycle
Message-ID: <20100725160641.GK31966@localhost>
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


  Greetings,

  Using an external usb 2 hdd with recent kernels with cryptsetup containers that
  contain lvm volumes. 

  After a suspend/resume cycle, with active lvm volumes, the mounted fs is "offline", 
  the dm-* devices don't respond to commands issued. No more access possible.
  
  Have to reboot to free the devices.

  Someone ever experienced that? Ideas to fix?


          Thanks,

                  Nils

