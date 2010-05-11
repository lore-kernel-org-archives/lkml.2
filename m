Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab0EKIrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:47:55 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:43221 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0EKIrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:47:53 -0400
Date: Tue, 11 May 2010 10:47:21 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.34-rc7: hctosys.c: unable to open rtc device (rtc0)
Message-ID: <20100511084721.GA13218@localhost>
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

  While booting this showed up in the logs:

[    0.000000] Linux version 2.6.34-rc7 (user@host) (gcc version 4.4.3 20100108 (prerelease) (Debian 4.4.2-9) ) #1 SMP PREEMPT Mon May 10 21:54:14 CEST 2010
[    4.505090] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

There hasn't been a change regarding this on my behalf. So maybe it's of interest..

  Cheers,

    Nils

