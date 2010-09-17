Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0IQHjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:39:01 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55814 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab0IQHjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:39:00 -0400
X-Sasl-enc: eKpNMxpvU4fkGZJfKG6DScsq9tDWiWoirh5wi9dclkbT 1284709138
Message-ID: <4C931B12.8060403@ladisch.de>
Date: Fri, 17 Sep 2010 09:38:58 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hungry for hardware timers
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>	<4C85F0E3.2050908@ladisch.de>	<AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>	<4C860043.9000501@ladisch.de>	<AANLkTimbDOb-iJgRmpEb29GVfP-K0_6TtvPSF7eK-2ts@mail.gmail.com>	<4C861A09.5020203@ladisch.de> <AANLkTinrtwMnvutZV+NSOyu9O8iXdRvBnUF7EBs-M4cM@mail.gmail.com>
In-Reply-To: <AANLkTinrtwMnvutZV+NSOyu9O8iXdRvBnUF7EBs-M4cM@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> I am planning to use hpet2 from modules. But currently it seems
> hpet_readl() and hpet_writel() are not accessible from outside the
> kernel. Is there any plans to export them.

hpet_ioctl_common was intended to be exported, but isn't.

Better use hrtimers.


Regards,
Clemens
