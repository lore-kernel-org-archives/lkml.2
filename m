Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab2KPMrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:47:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2KPMrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:47:18 -0500
Date: Fri, 16 Nov 2012 13:47:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Hard freeze after 'rfkill block bluetooth'
Message-ID: <alpine.LNX.2.00.1211161344430.20577@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got a hard freeze with HEAD at 1b42fc4 (i.e. past -rc4) after running 
rfkill block bluetooth.

Screen capture can be found at

	http://www.jikos.cz/jikos/junk/IMAG0264.jpg

(sorry for the bad picture quality, but I believe it's readable).

I am not able to reproduce it again.

-- 
Jiri Kosina
SUSE Labs
