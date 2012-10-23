Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2JWOqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:46:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33061 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2JWOqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:46:33 -0400
Message-ID: <5086ADC7.7060802@tilera.com>
Date: Tue, 23 Oct 2012 10:46:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile updates for 3.7-rc2
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This fixes one issue with compiler flags that can cause modules not
to load, and cleans up some warnings with ELF_R_xxx defines.

Chris Metcalf (2):
      arch/tile: avoid generating .eh_frame information in modules
      arch/tile: avoid build warnings from duplicate ELF_R_xxx #defines

 arch/tile/Makefile        |    4 ++++
 arch/tile/kernel/module.c |   10 ----------
 2 files changed, 4 insertions(+), 10 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

