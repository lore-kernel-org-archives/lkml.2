Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0EQKYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:24:43 -0400
Received: from mail.aixigo.de ([195.14.232.227]:30263 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0EQKYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:24:41 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 06:24:41 EDT
Message-ID: <4BF115DF.7090509@aixigo.de>
Date: Mon, 17 May 2010 12:09:35 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100412 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kvm network problem with Solaris 10u8 guest
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
the guest (even though some packets are lost), but ssh or other
TCP connections don't work.

rtl8139 and ne2k_pci are not even listed by "ifconfig -a" on
the guest.

Solaris 10u6 worked fine (using e1000).

Can anybody reproduce this problem?


Any helpful comment would be highly appreciated. Of course
I would be glad to help to track this down.

Harri
