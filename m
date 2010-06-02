Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab0FBP6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:58:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49415 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0FBP6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:58:49 -0400
Date: Wed, 2 Jun 2010 08:57:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: make ARM=arm menuconfig problem in mainline
Message-Id: <20100602085748.6771e025.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTilEYHVHJrj_KgF48OYCSEUcsKLi57Q_Y73d9va-@mail.gmail.com>
References: <AANLkTikC61Y9g-WbqwgGDghDSy2XtgraFSRoZYkHRGTG@mail.gmail.com>
	<AANLkTilEYHVHJrj_KgF48OYCSEUcsKLi57Q_Y73d9va-@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C067FB5.0150:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 20:04:28 +0530 Nobin Mathew wrote:

> adding linux-arm-kernel@lists.infradead.org
> 
> Hi,
> 
> The following entry creates problem in ARM System type menu. I am
> using a Fedora 12 system.

What kind of problem does it create?
It seems to work for me (on f11, not f12).
Does it have something to do with F12 specifically?


> Length of bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
> S3C2442, S3C2443, S3C2450" is the problem. How can I fix it.

Describe the problem, please.

> config ARCH_S3C2410
>        bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
> S3C2442, S3C2443, S3C2450"
>        select GENERIC_GPIO
>        select ARCH_HAS_CPUFREQ
>        select HAVE_CLK
>        select ARCH_USES_GETTIMEOFFSET
>        help
>          Samsung S3C2410X CPU based systems, such as the Simtec Electronics
>          BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
>          the Samsung SMDK2410 development board (and derivatives).
> 
>          Note, the S3C2416 and the S3C2450 are so close that they even share
>          the same SoC ID code. This means that there is no seperate machine
>          directory (no arch/arm/mach-s3c2450) as the S3C2416 was first.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
