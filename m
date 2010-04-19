Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0DSEbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 00:31:33 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:37162
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0DSEbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 00:31:31 -0400
Message-ID: <4BCBDCA1.9030500@myrealbox.com>
Date: Mon, 19 Apr 2010 00:31:29 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Low-Level and Long-Term Battery Control
References: <w2r45cc95261004130535y80da503ev5389bb4a97bdd58f@mail.gmail.com>
In-Reply-To: <w2r45cc95261004130535y80da503ev5389bb4a97bdd58f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mohamed Ikbel Boulabiar wrote:
> Hi,
> 
> Is there any function in the Linux kernel that control the
> charging/discharging of the battery to provide better lifespan ?
> (add some years to its life ?)
> 
> For Laptops, it is better to extract the battery from the Laptop when
> the computer will be on power for a long period.
> I ask if the kernel can do such control without the user intention and
> in an automatic way.
> 
> Some BIOS provide to the user to select whether to block the battery
> charging to 50% to make it stand for more time.
> And Many people (like me) forget their laptops on power until the
> battery no more can hold energy after 2minutes of no power.
> 

On ThinkPads, tp_smapi (not in the kernel.org kernel) can do it.  I'd 
like to see this feature standardized in sysfs.

--Andy
