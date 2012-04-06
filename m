Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2DFNkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:40:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36843 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab2DFNkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <201203250232.29843.vapier@gentoo.org>
References: <CAN628AHjJeLD_bUNGSDmBOo_EW=aFML-VZ-A4GRyAi2eNwA1yw@mail.gmail.com>
	<201203250232.29843.vapier@gentoo.org>
Date: Fri, 6 Apr 2012 14:40:45 +0100
Message-ID: <CAN628AE6GLEUGke68z0rfbZWvmEuTsBQ0EHcy4mzC6Bz3bYX5Q@mail.gmail.com>
Subject: Re: Utility code to generate a VMUFAT filesystem
From: Adrian McMenamin <lkmladrian@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh <linux-sh@vger.kernel.org>,
        Adrian McMenamin <adrianmcmenamin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2012 14:32, Mike Frysinger <vapier@gentoo.org> wrote:
> On Wednesday 21 March 2012 00:41:17 Adrian McMenamin wrote:
>> /*
>>  * mkfs.vmufat.c - make a linux (VMUFAT) filesystem
>>  *
>>  * Copyright (c) 2012 Adrian McMenamin adrianmcmenamin@gmail.com
>>  * Licensed under Version 2 of the GNU General Public Licence
>>  *
>>  * Parts shamelessly copied from other mkfs code
>>  * copyright Linus Torvalds and others


With thanks to Mike - a new version of mkfs.vmufat.c is now available
at https://github.com/mcmenaminadrian/mkfs.vmufat

I have tried to incorporate all his points - even the bits where he
was complaining about the code I lifted from Linus's work :)


Any and all feedback welcome.

Adrian
