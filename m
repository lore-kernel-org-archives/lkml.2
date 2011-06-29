Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1F2RCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:02:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39855 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1F2RCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:02:17 -0400
Message-ID: <4E0B5A8F.4020905@gmail.com>
Date: Wed, 29 Jun 2011 20:02:07 +0300
From: Alexander Zhaunerchyk <alex.vizor@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Lightning/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #36452] Artifacts with 3.0-rc1 on SandyBridge
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>	<XWjMN7gBoXK.A.bzD.Ia6BOB@chimera> <20110629094717.10df4637@jbarnes-desktop>
In-Reply-To: <20110629094717.10df4637@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was with integrated graphics. But seems this is fixed in rc5 or 
rc5+ because after compiling rc5 I  didn't see these artifacts anymore

On 29.06.2011 19:47, Jesse Barnes wrote:
> On Sun, 26 Jun 2011 23:23:44 +0200 (CEST)
> "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
>
>> This message has been generated automatically as a part of a summary report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.39.  Please verify if it still should be listed and let the tracking team
>> know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36452
>> Subject		: Artifacts with 3.0-rc1 on SandyBridge
>> Submitter	: Alex Zhavnerchik<alex.vizor@gmail.com>
>> Date		: 2011-06-01 13:55 (26 days old)
> Is this with integrated or discrete graphics?  Have you tried to bisect
> yet?
>
