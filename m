Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1HAJpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:45:10 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:34479 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1HAJpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:45:07 -0400
Message-ID: <4E367256.8020206@ct.jp.nec.com>
Date: Mon, 01 Aug 2011 18:31:02 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
References: <20110720082640.GZ7561@ics.muni.cz> <4E280964.6070000@ct.jp.nec.com> <20110721132627.GY7561@ics.muni.cz> <4E291F28.2040609@ct.jp.nec.com> <20110722081903.GB7561@ics.muni.cz> <4E2A7806.1060601@ce.jp.nec.com> <20110724221619.GM16487@ics.muni.cz>
In-Reply-To: <20110724221619.GM16487@ics.muni.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

Lukas Hejtmanek wrote:
> On Sat, Jul 23, 2011 at 04:28:06PM +0900, Jun'ichi Nomura wrote:
>> As Kiyoshi suggested, it is important to know whether this
>> problem occurs with the latest kernel.
>> So if you could try 3.0, it would be very helpful.
> 
> so, do I need to check recent kernel as the patch works for me?

Yes, please.
(Unfortunately my storage has been broken today :-<)

CPU usage seems to be one of the reasons for your case, but I
still cannot understand why memory pressure is needed.
I want to know your problem also occurs on 3.0 without the patch.

Thanks,
Kiyoshi Ueda
