Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab1DRURk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:17:40 -0400
Received: from smtp10.mail.sp.isp-net.nl ([217.149.192.65]:41833 "EHLO
	smtp10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1DRURi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:17:38 -0400
Message-ID: <4DAC9C41.7040908@xmsnet.nl>
Date: Mon, 18 Apr 2011 22:17:05 +0200
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #31322] 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs
 mplayer distortions
References: <sam8u5dLkaB.A.afE.53uqNB@chimera> <IqJL5EkbqD.A.MTF.r4uqNB@chimera>
In-Reply-To: <IqJL5EkbqD.A.MTF.r4uqNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2011 03:52 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31322
> Subject		: 2.6.38-rc echo 3>  /proc/sys/vm/drop_caches repairs mplayer distortions
> Submitter	: Hans de Bruin<jmdebruin@xmsnet.nl>
> Date		: 2011-03-14 21:34 (35 days old)
> Message-ID	:<4D7E89E7.3080505@xmsnet.nl>
> References	: http://marc.info/?l=linux-kernel&m=130014181919827&w=2
>

The  bug is still there and affecting kernels up to 2.6.39-rc3

-- 
Hans

