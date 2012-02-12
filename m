Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2BLXjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 18:39:12 -0500
Received: from 1wt.eu ([62.212.114.60]:62390 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab2BLXjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 18:39:10 -0500
Date: Mon, 13 Feb 2012 00:39:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.27.61
Message-ID: <20120212233908.GA31079@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.27.61.

It fixed a build regression for i386 introduced in 2.6.27.60. You don't
need to upgrade if it built fine for you.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.61.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.61.xz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.61.gz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/ChangeLog-2.6.27.61

The updated 2.6.27.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.27.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.27.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.27.y


  Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |    build:OK            -
          i386 |    build:OK         boot:OK

Thanks to all reviewers, and to Greg for the final packaging.
Willy

---------
 Makefile                 |    2 +-
 arch/x86/kernel/reboot.c |    8 --------
 2 files changed, 1 insertions(+), 9 deletions(-)

Summary of changes from 2.6.27.60 to 2.6.27.61
==============================================
Willy Tarreau (2):
      Revert "x86: Make Dell Latitude E5420 use reboot=pci"
      Linux 2.6.27.61

