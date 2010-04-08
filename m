Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab0DHPAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:00:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38559 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357Ab0DHPAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:00:37 -0400
X-Sasl-enc: HDqV8WGu6h435PDeAHt678fvdbUk5xZLlf4lCgTc6jCC 1270738836
Message-ID: <4BBDEF93.6070306@ladisch.de>
Date: Thu, 08 Apr 2010 17:00:35 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Failed to initialize MSI interrupts && ioremap reserve_memtype
 failed -22
References: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>	 <4BBC9CA1.5080102@ladisch.de>	 <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>	 <4BBD1957.90502@gmail.com>	 <k2l5bdc1c8b1004072051h957c3f1crf0a139bd96a093a4@mail.gmail.com>	 <v2h51f3faa71004072054y4733bf9bq80a04574bebbadba@mail.gmail.com>	 <4BBD7997.1020803@ladisch.de> <l2v5bdc1c8b1004080753k7787e635p4a70d4a1a777984d@mail.gmail.com>
In-Reply-To: <l2v5bdc1c8b1004080753k7787e635p4a70d4a1a777984d@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Knecht wrote:
> ioremap reserve_memtype failed -22
> phys_addr: 0xcf7fe000, size: 0x2000

What is at this address in /proc/iomem?

> Call Trace:
>  [<ffffffff8101b7ee>] ? __ioremap_caller+0x1e2/0x30e
>  [<ffffffffa052345b>] ? _nv006553rm+0x3a/0x40 [nvidia]

I didn't find this function name in the kernel source ...


Regards,
Clemens
