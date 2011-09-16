Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1IPVUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:20:37 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:4922 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932294Ab1IPVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:20:36 -0400
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 17:20:36 EDT
Message-ID: <4E73BB61.7020407@hetnet.nl>
Date: Fri, 16 Sep 2011 23:10:57 +0200
From: Henk de Groot <henk.de.groot@hetnet.nl>
Reply-To: henk.de.groot@hetnet.nl
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: David Kilroy <kilroyd@googlemail.com>
CC: linux-kernel@vger.kernel.org, greg@kroah.com, pe1dnn@amsat.org
Subject: Re: [PATCH 00/13] wlags49_h2: Various cleanups
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2011 21:08:27.0587 (UTC) FILETIME=[C7706930:01CC74B4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Nice work! It looks like you managed to understand how some of the HCF 
code actually works... I found it rather unreadable but I also lack the 
knowledge of the inner working of Agere's Hermes II chip.

Op 16-9-2011 1:20, David Kilroy schreef:
> Verified be recompiling and confirming there are no changes to the
> binary (except line offsets from calls to mdd_assert).
I applied your patches against the current 3.0 linux kernel driver code 
and compiled it on my Ubuntu 11.04 system (2.6.38-11). I can confirm the 
modified driver is still working okay using a Thomson Speedtouch 110 Wifi 
card with WEP. WPA was - and I guess still is - non functional. The driver 
is very stable in WEP mode; the laptop is frequently used for bittorrent 
and Tweetdeck and never crashes.

The only known problem (besides WPA) is removal and reinserting the PCMCIA 
card. It is not recognized anymore on that slot. The card works on a 
second PCMCIA slot. This is old behaviour and not due to your changes 
(however this worked with older kernels).

Kind regards,

Henk.

