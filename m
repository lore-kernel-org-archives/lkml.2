Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1GDFb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:31:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62004 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1GDFb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110703162329.GA28131@suse.de>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
	<1309702581-16863-3-git-send-email-akinobu.mita@gmail.com>
	<20110703162329.GA28131@suse.de>
Date: Mon, 4 Jul 2011 14:31:25 +0900
Message-ID: <CAC5umyh_25z9LV=T86807ey8yZRGwmhsPG44OqZdtcR-3wzb4Q@mail.gmail.com>
Subject: Re: [PATCH 2/7] debugfs: add debugfs_create_int
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/4 Greg KH <gregkh@suse.de>:
> On Sun, Jul 03, 2011 at 11:16:16PM +0900, Akinobu Mita wrote:
>> Introduce debugfs_create_int() for creating a debugfs file that is used to
>> read and write an int value.
>
> Um, what's wrong with the existing s32 and s64 versions that debugfs
> already provides?

I couldn't find s32 version in linux/debugfs.h

> userspace doesn't know what "int" means for the kernel as it might be
> running in 32bit mode with a 64bit kernel.  That is why this isn't a
> good idea, so please convert your other patch to use the existing api
> and change the variable type in your patch.

Shoud I add debugfs_create_s32() instead of debugfs_create_int() for
this?
