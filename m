Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0IQSoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:44:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:39536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab0IQSoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:44:05 -0400
Date: Fri, 17 Sep 2010 20:44:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Lech Perczak <lech.perczak@multivision.pl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] hid: Fix for A4Tech RP-649 horizontal scrollwheel
 (updated)
In-Reply-To: <4C9289E5.3020400@multivision.pl>
Message-ID: <alpine.LNX.2.00.1009172042550.26813@pobox.suse.cz>
References: <4C9289E5.3020400@multivision.pl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, Lech Perczak wrote:

> 
> 
> From: Lech Perczak<lech.perczak@multivision.pl>
> 
> - Add USB device ID of A4Tech RF mouse receiver (09da:001a) used with
> RP-649(Z) mice
> - Enable fix for their horizontal scroll wheel behaviour, associate it 
with B8
> hack.
> - Blacklist the new device ID in hid-core.c
> 
> Signed-off-by: Lech Perczak<lech.perczak@multivision.pl>
> ---
> diff -up hid/hid-a4tech.c.orig hid/hid-a4tech.c
> --- hid/hid-a4tech.c.orig	2010-08-02 00:11:14.000000000 +0200
> +++ hid/hid-a4tech.c	2010-09-09 17:51:23.000000000 +0200

In the future, please send the patches in a form that they can be applied 
from the toplevel kernel source directory with 'patch -p1'. I have fixed 
it up for this patch and applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
