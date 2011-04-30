Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab1D3WiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 18:38:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33324 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab1D3WiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 18:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WQdZZTISLVBfIOcrosDgbUT74+Qf5Tarm2FFsfq099DiK2P80Z1wZptmijq0kQ4QRa
         h2nF/5SUK8Oj5GL6loy7JGnOWEa6T9iIvmM8G3NjyMxEC/HvrKlJC/c/4ppX1wIcr30E
         V+KxegWyw/tGtkRxA9DhVjSZrSirLOILIurF0=
Message-ID: <4DBC8F4F.5020009@gmail.com>
Date: Sat, 30 Apr 2011 15:38:07 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #31702] ath5k phy2: failed to wakeup the MAC Chip
References: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera> <9nxEC7x0HFO.A.5HG.FyGvNB@chimera>
In-Reply-To: <9nxEC7x0HFO.A.5HG.FyGvNB@chimera>
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31702
> Subject		: ath5k phy2: failed to wakeup the MAC Chip
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2011-03-22 19:15 (40 days old)
>
>
>

seems fixed with the current over here.

Justin P. Mattock
