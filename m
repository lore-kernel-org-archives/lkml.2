Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2KRKvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 05:51:31 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:51427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2KRKva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 05:51:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Ellis <m@rkellis.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: PROBLEM: REGRESSION in drivers/platform/x86/dell-laptop.c
Date: Sun, 18 Nov 2012 11:55:54 +0100
Message-ID: <1604749.ryBaIPphFW@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc6; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50A8BCA6.7080102@rkellis.com>
References: <50A8BCA6.7080102@rkellis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 18, 2012 06:47:02 PM Mark Ellis wrote:
> 1. rfkill code removal causes hang
> 
> 2. the rfkill code was removed from this driver in commit 
> 53039f222c548bfc119eea6df4dca2b57550e271

That doesn't seem to be the hash of the commit in question.  This one
is just a merge fix.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
