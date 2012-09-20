Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2ITNae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:30:34 -0400
Received: from tex.lwn.net ([70.33.254.29]:45002 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab2ITNac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:30:32 -0400
Date: Thu, 20 Sep 2012 07:30:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Allen Huang (=?UTF-8?B?6buD5YGJ5qC8?=) 
	<allen_huang@davicom.com.tw>,
        linux-kernel@vger.kernel.org,
        "'Michael Chen'" <michael_chen@mail.davicom.com.tw>,
        "'Charles'" <charles_tsai@davicom.com.tw>,
        "'Joseph Chang'" <joseph_chang@mail.davicom.com.tw>
Subject: Re: Davicom DM9000C driver
Message-ID: <20120920073027.15be4002@hpe.lwn.net>
In-Reply-To: <201209200908.00519.arnd@arndb.de>
References: <20120919055333.3ECF95F94D@mail.davicom.com.tw>
	<20120919173524.7bf4a974@lwn.net>
	<201209200908.00519.arnd@arndb.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012 09:08:00 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> More importantly, the patch should be against the version that is
> already present in the kernel as drivers/net/ethernet/davicom/dm9000.c,
> which appears to be mostly the same as the version that is submitted
> here.

Sigh.  Leave it to me to miss the most important part of all.  Ignore
me, please, and listen to Arnd - good advice in general.

jon
