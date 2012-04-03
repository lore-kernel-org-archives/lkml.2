Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2DCHQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:16:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44592 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2DCHQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:16:02 -0400
MIME-Version: 1.0
In-Reply-To: <4F7A9D5C.8040402@silka.with-linux.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
Date: Tue, 3 Apr 2012 12:46:01 +0530
Message-ID: <CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Kelly Anderson <kelly@silka.with-linux.com>
Cc: Ben Greear <greearb@candelatech.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kelly,

could you please try to see by disabling ASPM in the boot option and
see if it helps

http://linuxwireless.org/en/users/Documentation/ASPM

pcie_aspm=      [PCIE] Forcibly enable or disable PCIe Active State Power
off     Disable ASPM.

-- 
thanks,
shafi
