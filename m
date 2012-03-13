Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2CMRE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:04:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36814 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab2CMREv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:04:51 -0400
Message-ID: <4F5F7E2F.30305@gmail.com>
Date: Wed, 14 Mar 2012 02:04:47 +0900
From: Akio Idehara <zbe64533@gmail.com>
MIME-Version: 1.0
To: mjg59@srcf.ucam.org
CC: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charles@schwieters.org, corentin.chary@gmail.com,
        seth.forshee@canonical.com
Subject: Re: [PATCH] toshiba_acpi: Add support for transflective LCD
References: <4F3ECEED.9000206@gmail.com> <20120312141118.GB11375@srcf.ucam.org>
In-Reply-To: <20120312141118.GB11375@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also think it seems a good idea.  I'll try to make a new patch using your suggestion.

BTW, I have one question about disabling backlight interface.
My toshiba laptop has three sysfs backlight interfaces,
"acpi_video0", "intel_backlight" and "toshiba".
Fedora16 is always using "acpi_video0" interface.
If I add acpi_backlight=vendor in boot param,
then Fedora16 uses "intel_backlight".
# "toshiba" is lowest priority.
So I want to know how to disable "intel_backlight" interface.
Or enable "toshiba" interface only.

Matthew Garrett wrote:

> Is there any userspace that currently manipulates the bl_power field? 
> I'm wondering whether this should actually just be implemented by adding 
> an extra level to the backlight and having 0 change to transflective 
> mode.
> 


