Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1ANK4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:56:49 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45895 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab1ANK4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:56:43 -0500
Date: Fri, 14 Jan 2011 12:56:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: balbi@ti.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: error in 2.6.37-git10
Message-ID: <20110114105639.GL2476@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D301CA5.503@example.com>
 <20110114095745.GD2476@legolas.emea.dhcp.ti.com>
 <4D302067.2000203@example.com>
 <20110114100831.GE2476@legolas.emea.dhcp.ti.com>
 <4D3021AE.5020607@example.com>
 <4D302B0E.1080306@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D302B0E.1080306@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 14, 2011 at 11:53:02AM +0100, Piotr Hosowicz wrote:
> >I corrected and am building again. Hope this helps.
> 
> I don't know why but it failed again. I disabled and am building again.

for me it builds ok:

  CC [M]  fs/ecryptfs/dentry.o
  CC [M]  fs/ecryptfs/file.o
  CC [M]  fs/ecryptfs/inode.o
  CC [M]  fs/ecryptfs/main.o
  CC [M]  fs/ecryptfs/super.o
  CC [M]  fs/ecryptfs/mmap.o
  CC [M]  fs/ecryptfs/read_write.o
  CC [M]  fs/ecryptfs/crypto.o
  CC [M]  fs/ecryptfs/keystore.o
  CC [M]  fs/ecryptfs/messaging.o
  CC [M]  fs/ecryptfs/miscdev.o
  CC [M]  fs/ecryptfs/kthread.o
  CC [M]  fs/ecryptfs/debug.o
  LD [M]  fs/ecryptfs/ecryptfs.o

weird.

-- 
balbi
