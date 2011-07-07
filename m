Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab1GGEXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:23:54 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:34657 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1GGEXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:23:53 -0400
Message-ID: <4E1534DC.3020306@t-online.de>
Date: Thu, 07 Jul 2011 06:23:56 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: axboe@kernel.dk, kay.sievers@vrfy.org,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.38.8] Bisected to commit 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09
References: <4E11BAE0.5020208@t-online.de> <20110707003338.GA25302@suse.de>
In-Reply-To: <20110707003338.GA25302@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: SUb8AwZXgh5+UYAsbUl71ByixkpJARHflhPQ9P9sA7xbSCL3pg6oJsJrnoC55OqggF
X-TOI-MSGID: 655d3401-2804-4b5e-82c3-d062f399f902
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.07.2011 02:33, schrieb Greg KH:
> On Mon, Jul 04, 2011 at 03:06:40PM +0200, Knut Petersen wrote:
>> Hi everybody!
>>
>> An openSuse 11.2 system reliably refused to boot properly with kernel 2.6.38.8
>> although the prior 2.6.38.y kernels worked fine.  After a few seconds booting
>> stopped. Several <ctrl-c> did help, but a lot of services were not started properly,
>> only the root partition was available. Nothing unusual could be found in the
>> kernel messages.
>>
>> I bisected the problem to commit 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09.
>>
>> That gave me the idea to disconnect the Plextor PX-755A dvd drive  and to
>> try 2.6.38.8 again. It booted without problem.
> Does the 2.6.39.2 kernel work properly for you?
>
Yes.  Kernel 2.6.38[,1,2,3,4,5,6,7] 2.6.39[1,2] 3.0-git are ok, only 2.6.38.8 is broken in the
way described above.

cu,
 knut
