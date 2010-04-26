Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0DZNvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:51:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab0DZNvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:51:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH] USB: sisusbvga: Remove the BKL from open
Date: Mon, 26 Apr 2010 15:50:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Oliver Neukum <oneukum@suse.de>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>
References: <1272191830-23675-1-git-send-email-abogani@texware.it> <201004261515.56750.arnd@arndb.de> <w2t63a49ef41004260630o31d81ff0qd98cfdace7e73ce0@mail.gmail.com>
In-Reply-To: <w2t63a49ef41004260630o31d81ff0qd98cfdace7e73ce0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004261550.49512.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19WlzcTG+IP7IGJhBQy4VS4IPQ5QARCuEEOMOq
 8dRGCSJTrbUrdhiqXbrQOVNmj7ibcjTxvSm9MQZHZxTwyzZ4TD
 UyLUVceK7lt2sk0KO9U7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010, Alessio Igor Bogani wrote:
> It is what effectively I'm trying to do!
> 
> The first part of this work is already present in USB subsystem
> maintainer tree (aka greg) at:
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/usb/usb-sisusbvga-remove-the-bkl-from-ioctl.patch
> 

Ok, looks good then. I just wouldn't bother splitting the work into two patches if you
want to do this for more drivers.

	Arnd
