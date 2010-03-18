Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0CRWEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:04:53 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:57471 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750Ab0CRWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:04:49 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] rt2500usb broken since 2.6.29
Date: Thu, 18 Mar 2010 23:04:41 +0100
User-Agent: KMail/1.9.10
Cc: Luis Correia <buga@loide.net>, linux-kernel@vger.kernel.org
References: <201003182246.54889.linux@rainbow-software.org> <880c1631003181451r7669428ctee7adc867979bc25@mail.gmail.com>
In-Reply-To: <880c1631003181451r7669428ctee7adc867979bc25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003182304.43196.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 March 2010 22:51:18 Luis Correia wrote:
> Hi,
>
> On Thu, Mar 18, 2010 at 21:46, Ondrej Zary 
<linux@rainbow-software.org>wrote:
> > Hello,
> > rt2500usb is broken since kernel 2.6.29. It has been discussed before but
> > never solved:
> > http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
> > https://bugzilla.redhat.com/show_bug.cgi?id=484888
> >
> > I have Asus WL-167G and it really does not work. Scanning works,
> > association
> > too but no packets can be sent (looks like receive works because tcpdump
> > shows packets from other machines). DHCP fails (No DHCPOFFERS received).
> >
> > The problem is caused by this patch:
> >
> > rt2x00: Implement HW encryption (rt2500usb)
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >;h=dddfb478b26e29a2b47f655ec219e743b8111015
> >
> > Removing it from 2.6.29 restores the functionality.
> >
> > --
> > Ondrej Zary
>
> you can prevent hardware encryption by supplying "nohwcrypt=1" to the
> driver.
> (modinfo rt2500usb)

That did not work. Maybe that was because I just unloaded the rt2500usb module 
and loaded it again with nohwcrypt=1 without rebooting the machine. Then I 
removed the HW encryption, recompiled and reloaded and it did not work 
either. It started to work only after reboot.

Does the HW encryption really work with any rt2500usb hardware? How can I help 
to fix it? Or maybe it should be disabled by default.

>
> Luis Correia
> rt2x00 project admin


-- 
Ondrej Zary
