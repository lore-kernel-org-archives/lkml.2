Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1ECTdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:33:06 -0400
Received: from christianhoffmann.info ([88.175.101.52]:59436 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1ECTdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:33:05 -0400
Message-ID: <4DC0586C.5010102@christianhoffmann.info>
Date: Tue, 03 May 2011 21:33:00 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>	 <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>	 <1304372955.3226.15.camel@work-vm>	 <4DBF2FB4.8000304@christianhoffmann.info> <1304382664.3226.24.camel@work-vm>
In-Reply-To: <1304382664.3226.24.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hm.. I wonder if the MSI quirk mucks up the hpet and acpi pm?
>
> Could you send me the full dmesg output both with and without the
> 08ec0c58fb8a05d3191d5cb6f5d6f81adb419798 commit applied?

Here we go:

Working (08ec0c58fb8a05d3191d5cb6f5d6f81adb419798 - 1)
http://pastebin.com/hwYnBZrC

Not working (08ec0c58fb8a05d3191d5cb6f5d6f81adb419798)
http://pastebin.com/i1GaxeXk

> Also, does the same issue crop up if you compile the kernel with
> CONFIG_PCI_MSI disabled?

I don't seem to be able to switch that off. It gets reset when building 
the kernel (dependencies?). I then tried to use kernel param pci=nomsi, 
but the problem persists.

Rgds,
Chris

