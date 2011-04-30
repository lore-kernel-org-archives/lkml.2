Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1D3Whx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 18:37:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33324 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab1D3Whu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 18:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cE1tctFi+ID2jrroeLMdpDXFT394Ic9FmYI7wXMYkCWKARPvjNSrmJ2ArgLYVHnznF
         idZQJUet9b2hbOYuCudbzDiWcy6NPAXK5Jg7U31x2lgDnMPM4Myi9qQkRce9znNpkhwX
         Xm75qzLVfCx6gPNrRAlYG+RY7w0+2XpX+7Vsk=
Message-ID: <4DBC8F30.4000301@gmail.com>
Date: Sat, 30 Apr 2011 15:37:36 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #30582] WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
 ath_stoprecv+0xc8/0xda [ath9k]()
References: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera> <9nxEC7x0HFO.A.z1G.0yGvNB@chimera>
In-Reply-To: <9nxEC7x0HFO.A.z1G.0yGvNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 01:17 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30582
> Subject		: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2011-03-03 5:47 (59 days old)
> Message-ID	:<AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=129913127722786&w=2
>
>
>

appologizes for not responding last week on this. Anyways I looked at 
the machine with the latest, and this is fixed over here(attached dmesg 
to the bug report)

Justin P. Mattock
