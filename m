Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0IMLZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:25:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0IMLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:25:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guillaume Chazarain <guichaz@gmail.com>
Subject: Re: [PATCH] Fix hiddev's use of usb_find_interface
Date: Mon, 13 Sep 2010 13:25:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
References: <1284319955-6014-1-git-send-email-guichaz@gmail.com>
In-Reply-To: <1284319955-6014-1-git-send-email-guichaz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131325.01768.arnd@arndb.de>
X-Provags-ID: V02:K0:XgQHok7XuJLOYPW20wvU/mdqJFCrQnXPfYBYgZRpLaR
 0DsmW2btCVTn4MYd6XBeeAt2+JW4ZUBuqTdoKIRqzVtXb3j3w/
 cH2aRq0O/hCt+NEm9nnRN32X4PrGYgYEhulb1Epsp2twy7VxYD
 pLZyfAMXIUgCuYhnUxdk/16xpXA0N4Z0Y/LStlgMD9JE5oEBHH
 mqzAM8j7C2nFFKdnMJa7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 September 2010, Guillaume Chazarain wrote:
> My macbook infrared remote control was broken by commit
> bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a:
> HID: hiddev: use usb_find_interface, get rid of BKL

Right, my bug. Sorry for the trouble you went through.

A few other people have reported the same and Jiri has done
a fix that was merged in 2.6.36-rc2.

	Arnd
