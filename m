Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1C0Uv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:51:26 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53078 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1C0UvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wvxttL7zNHCUztKSlAriwrvU9C6AReABO/vNs6hcpwBDH9gFtxYuXTZ9Ai3pIen0Hq
         824QDwx3Xr/cwkjzYeFT4Fr77qllD4yQvDp2TrMqdAMcDH1wcX8Nj/xc7JNa6nZk+wy4
         20IxQ0/5X1nuTky4P1jFjFCNR0GMIp/Dvs5C0=
Message-ID: <4D8FA346.7000703@gmail.com>
Date: Sun, 27 Mar 2011 13:51:18 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #30582] WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
 ath_stoprecv+0xc8/0xda [ath9k]()
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera> <40UNry85rJN.A.YfE.yn5jNB@chimera>
In-Reply-To: <40UNry85rJN.A.YfE.yn5jNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2011 01:27 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30582
> Subject		: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2011-03-03 5:47 (25 days old)
> Message-ID	:<AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=129913127722786&w=2
>
>
>

think this one os closed now.. but a new one has been opened:

https://bugzilla.kernel.org/show_bug.cgi?id=31702

Justin P. Mattock
