Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0KIImh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:42:37 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:11108 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0KIImd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:42:33 -0500
Date: Tue, 9 Nov 2010 09:42:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for 
 pr_fmt(fmt)
Message-ID: <20101109094223.376d8b80@endymion.delvare>
In-Reply-To: <20101109030723.GA22732@ericsson.com>
References: <1287713982.16920.39.camel@Joe-Laptop>
	<20101026110335.3a4c7679@endymion.delvare>
	<1288201301.4145.122.camel@Joe-Laptop>
	<20101028093529.503c3a28@endymion.delvare>
	<1288252476.1836.9.camel@Joe-Laptop>
	<20101028104354.6aaca07c@endymion.delvare>
	<1288390250.28828.228.camel@Joe-Laptop>
	<20101108133342.7217866c@endymion.delvare>
	<20101108165526.GA20229@ericsson.com>
	<1289236563.29216.328.camel@Joe-Laptop>
	<20101109030723.GA22732@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Mon, 8 Nov 2010 19:07:23 -0800, Guenter Roeck wrote:
> I'll start applying the patches to my next tree. I'll get back to you if I run
> into trouble.
> 
> Jean, do you want to take some of the patches, or should I take them all ?

I'll take the it87, lm78, pc87360, pc87427 and w83781d patches. Please
take all the rest. Thanks!

-- 
Jean Delvare
