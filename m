Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1GYH1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:27:31 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3981 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYH1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:27:24 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E2D1ACF.1010307@broadcom.com>
Date: Mon, 25 Jul 2011 09:27:11 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
Organization: Broadcom
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Guilherme Salazar" <gmesalazar@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: ieee80211 messages at startup (3.0 kernel)
References: <CA+Hmt2hyH3tZqSJjdOZfceGtpfHyTL4hh56ngXLHevOpVT07VA@mail.gmail.com>
In-Reply-To: <CA+Hmt2hyH3tZqSJjdOZfceGtpfHyTL4hh56ngXLHevOpVT07VA@mail.gmail.com>
X-WSS-ID: 6233C39D3DK3437278-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guilherme,

 > I've been seeing weird messages concerning ieee80211 driver at startup
 > after using 3.0.0 kernel.
 > I don't know whether that is a problem or just debugging messages,
 > since everything is working fine,
 > but I've attached the dmesg output (before and after using the 3.0.0)
 > and my config file.

this issue has been fixed in the staging-next repo, the fix is probably 
still on its way to the wireless repo. FYI, the commit on staging-next is:

-----------------
commit 37c962d195005d009e130e65a9e55960996c3cab
Author: Roland Vossen <rvossen@broadcom.com>
Date:   Wed Jun 29 16:48:22 2011 -0700

     staging: brcm80211: fix for reported log spam problem

     Every few minutes, this message would appear in syslog:

     ieee80211 ph0: wl_ops_bss_info_changed: BSS idle: true (implement)

     The message has been deleted, the driver requires no special action 
on this
     particular event (). See: 
https://bugzilla.kernel.org/show_bug.cgi?id=38162
-----------------

Bye, Roland.

