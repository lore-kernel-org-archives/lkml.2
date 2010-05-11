Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0EKOfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:35:23 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:40432 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab0EKOfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:35:21 -0400
Date: Tue, 11 May 2010 16:35:10 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: RE: 2.6.34-rc7: hctosys.c: unable to open rtc device (rtc0)
Message-ID: <20100511143510.GA6793@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511084721.GA13218@localhost>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there,

Sorry, my fault. Indeed, nothing changed on my behalf. But 
the msg is there for .33.3 also and probably caused by a 
rtc-cmos.ko missing in initrd (my interpretation now..).

Cheers,

Nils

