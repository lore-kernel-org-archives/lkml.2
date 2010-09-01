Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0IAHWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:22:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab0IAHWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:22:01 -0400
Message-ID: <4C7DFF2C.8070709@steinhoff.de>
Date: Wed, 01 Sep 2010 09:22:20 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: bn@niasdigital.com
Subject: [UIO]  SMX UIO interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:AbE5j/OkmyH+TQzOeNyNvKkwA5hQypSAvJ2eymg1qW6
 XlVSGWozuuJhVnI0xCDFWvpGhMkyxNTpEwRgc/knNs5dC4SaAN
 kvjE/hb/TmbYZJQ1/mGl/rTMiRdjUOM3/GnZ3z2WFB9GAp5xmV
 6UBAr/K8cZTqxNQMNP64GHkqTmwWagtbKlfHXdP7aD6sl7A92b
 2JF2xtE/MfDHNYuECK1Bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Ben,

I have a question about the SMX UIO Interface.

In the SMX module you are reading the data of the platform resourses:

     regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
     if (!regs) {
         dev_err(&dev->dev, "No memory resource specified\n");
         goto out_free;
     }

But who sets these data initially ?

Cheers

--Armin

