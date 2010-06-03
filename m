Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0FCKuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:50:18 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:8433 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab0FCKuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:50:16 -0400
X-RZG-AUTH: :PmMGcFK8W/5pU+Ks2M0NQC5NPKGZSjWcOhfQxYOYw6/VECD6LtnnCVwaCh0=
X-RZG-CLASS-ID: mo00
Message-ID: <4C0788E1.2030905@au-79.de>
Date: Thu, 03 Jun 2010 12:50:09 +0200
From: Robert Goldner <robert@au-79.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: staging RT2870 removed /etc/Wireless/... configuration files
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know that questions/notificatins about stating drivers are not 100%
welcome on this mailing list, but I see no other possibiliy to solve my
problem.

I used (very sucessful) a wireless-USB adapter (ID 148f:2770 Ralink
Technology, Corp.) with 2.6.32 and rt2870sta staging driver. I eddited
/etc/Wireless/RT2870STA/RT2870STA.dat to get n-speed running (with
success, according to many Howtos). I got speed rates ~235M (acc. to
iwconfig and also tested).

Now I tryed to change to 2.6.34 (thanks for all the work), but I only
got 54M. After checking serveral changelogs I read that the uggly
configuration by /etc/Wireless... was dropped in 2.6.33, and I´m not
able to find any hint how to enhance the wireless configuration to
n-seed again.

So any help/hint is welcome.

Best regards

Robert

