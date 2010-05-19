Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0ESNqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:46:19 -0400
Received: from mail.aixigo.de ([195.14.232.227]:7366 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab0ESNqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:46:18 -0400
Message-ID: <4BF3EBA8.5040808@aixigo.de>
Date: Wed, 19 May 2010 15:46:16 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100412 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kvm: network problem with Solaris 10u8 guest
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I am trying to run Solaris 10u8 as a guest in kvm (kernel
2.6.33.2). Problem: The virtual network devices don't work
with this Solaris version.

e1000 and pcnet work just by chance, as it seems. I can ping
the guest (even though some packets are lost). I cannot use
ssh to login.

rtl8139 and ne2k_pci are not even listed by "ifconfig -a" on
the guest.

Solaris 10u6 worked fine (using the e1000 emulation). Same for
the Linux guests.

Can anybody reproduce this problem?


Any helpful comment would be highly appreciated. Of course
I would be glad to help to track this down.

Harri
