Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0FXHOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:14:06 -0400
Received: from fep14.mx.upcmail.net ([62.179.121.34]:12586 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0FXHOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:14:05 -0400
X-SourceIP: 77.57.188.152
Message-ID: <4C2305A8.4070708@odi.ch>
Date: Thu, 24 Jun 2010 09:13:44 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org> <4C224502.2040206@kernel.org>
In-Reply-To: <4C224502.2040206@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=M71sKKeyFebLYdq5hFNIGMR02ATQkL1qNhm49ttUYSY= c=1 sm=0 a=mI6YO6ZdSLUA:10 a=8nJEP1OIZ-IA:10 a=Mz90EqO6uu3MQq1Bor4A:9 a=TdeHSLVz4RCYU8jXMPF5QHwLRHEA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.06.2010 19:31, Tejun Heo wrote:
> Meh, it won't work.  It's failing softreset so we should be checking
> reset try counts.  I'll try to write up something tomorrow.

I am happy to try patches. The problem shows up maybe once a month only,
however. Interestingly it only occurs on ata2 with a IBM hdd, never on the first
channel with a maxtor. I can also try and attach the dvd on the first channel
and see if that makes any difference.

ata1.00: ATA-5: MAXTOR 6L020J1, A93.0500, max UDMA/133
ata2.00: ATA-5: IC25N030ATCS04-0, CA3OA71A, max UDMA/100
ata2.01: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-115  0127, E1.27, max UDMA/33

Thanks.
 Ortwin
