Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2BUKRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:17:35 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55530 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab2BUKRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:17:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of lisarden@gmail.com designates 10.112.24.196 as permitted sender) smtp.mail=lisarden@gmail.com; dkim=pass header.i=lisarden@gmail.com
MIME-Version: 1.0
Date: Tue, 21 Feb 2012 13:17:32 +0300
Message-ID: <CAP3+TEq76h=Bbb37Jj8_RRZDw=NhVAxPCLt1ZGdxQH1vnLM+Aw@mail.gmail.com>
Subject: ks8851 speed regression
From: Maxim Podbereznyy <lisarden@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I noticed the regression in speed for ks8851 driver (Micrel
KSZ8851-SNL). I used this part with kernel 2.6.32 and the speed was
1MB/s. Then the driver code was changed and for current Linux version
linux-3.0.17-r115c the speed is 745kB/s. 25% speed reduce is indeed
noticeable.

I use Angstrom Linux built in OE environment.
Target board is Beagleboard C4.

regards,
Max
