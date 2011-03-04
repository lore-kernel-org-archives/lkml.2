Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab1CDP5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:57:15 -0500
Received: from server103.greatnet.de ([83.133.97.6]:33038 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab1CDP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:57:14 -0500
Message-ID: <4D710BD2.3070303@nachtwindheim.de>
Date: Fri, 04 Mar 2011 16:57:06 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/7] x86: remove superflous goal definition of tsc_sync
References: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>	<AANLkTi=zU=N35RYmcSEkoLNAycQy7Cfcq3jHBYu+dq1O@mail.gmail.com> <AANLkTimptB1K3Kc+Hy1JbY=38pHSp0FfjA1LAKniLV2m@mail.gmail.com>
In-Reply-To: <AANLkTimptB1K3Kc+Hy1JbY=38pHSp0FfjA1LAKniLV2m@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.03.2011 13:50, schrieb Cyrill Gorcunov:
>> Probably we better write it this way:
>>
>> - obj-$(CONFIG_SMP)              += smpboot.o tsc_sync.o
>> - obj-$(CONFIG_X86_64_SMP)       += tsc_sync.o
>>
>> + obj-$(CONFIG_SMP)              += smpboot.o
>> + obj-$(CONFIG_SMP)              += tsc_sync.o
>>
 
Yes, I see what you mean. Removing/adding one item on such a multiple item
line makes muddled diffs.

Thank you for friendly reviewing, patience and your Acked-by,

Henrik Kretzschmar


