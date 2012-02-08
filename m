Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2BHA1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:27:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65166 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab2BHA1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:27:10 -0500
From: Olof Johansson <olof@lixom.net>
To: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, mjg@redhat.com
Subject: [PATCH v4 0/5] [RESEND] x86: efi: cleanups and basic 32/64-bit support
Date: Tue,  7 Feb 2012 16:25:27 -0800
Message-Id: <1328660732-27263-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series allows basic booting of a 32-bit kernel on 64-bit EFI and vice
versa.  It's needed by Chrome OS, and we've been carrying a nasty hack
to do it that I've cleaned up and made sure it works in both directions.

Tested on Chrome OS for 64-bit EFI 32-bit kernel. Tested with an old
MacBook for 32-bit EFI, 64-bit kernel.

Note that this is required, but not sufficient, for full platform support for
EFI in a mixed environment. There is no handling of runtime services, and no
thunking for going in and out of firmware in a different mode.


Resend of the last posted version. Acked by Matt, and Matthew seems to be OK
with it as well (see http://marc.info/?l=linux-kernel&m=132578786105542).

Please consider for 3.4 merge window. Thanks!


-Olof


Changelog is:                                                                                                               
v4:
* Removed bogus memdesc warning printout
* Fixed up printk formatting, removing redundant EFI output
* Some of the earlier cleanup was accidentally reverted by this patch, fixed.                                                                      
* Reworded some messages to not have to line wrap printk strings  

v3:                                                                                                                                                
* Reorganized to a series of patches to make it easier to review, and                                                                              
  do some of the cleanups I had left out before.                                                                                                   

v2:                                                                                                                                                
* Added graceful error handling for 32-bit kernel that gets passed                                                                                 
EFI data above 4GB.                                                                                                                              
* Removed some warnings that were missed in first version.                                                                                         



