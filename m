Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab0DGMZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:25:34 -0400
Received: from khc.piap.pl ([195.187.100.11]:46384 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713Ab0DGMZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:25:31 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 08:25:30 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Frank Hu <frank.hu.2001@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Joel Fernandes <agnel.joel@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
	<g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
	<4BBB7AC9.5060008@zytor.com>
	<o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
	<4BBB8F07.60401@zytor.com>
	<p2q8f84f9951004061315z7d2be34aj41b5052cf20879f3@mail.gmail.com>
Date: Wed, 07 Apr 2010 14:16:27 +0200
In-Reply-To: <p2q8f84f9951004061315z7d2be34aj41b5052cf20879f3@mail.gmail.com>
	(Frank Hu's message of "Tue, 6 Apr 2010 13:15:49 -0700")
Message-ID: <m34ojn8nl0.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Hu <frank.hu.2001@gmail.com> writes:

> thought that you can only configure how to split the VM like 1G/3G or
> 2G/2G. But the DMA zone size, the 128MB space for I/O is not
> configurable. The NORMAL zone size will be deducted based on the VM
> Split and some hard coded DMA zone and 128 MB space size.

Only the DMA zone size if fixed - a hardware property of PC/AT-style DMA
controllers and ISA bus.
-- 
Krzysztof Halasa
