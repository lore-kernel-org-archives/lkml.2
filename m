Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1EXJkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:40:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32956 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1EXJkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:40:11 -0400
Message-ID: <4DDB7CF6.6080900@ti.com>
Date: Tue, 24 May 2011 10:40:06 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
References: <1306152491.2968.9.camel@phoenix> <20110523143323.GA17298@opensource.wolfsonmicro.com>
In-Reply-To: <20110523143323.GA17298@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/11 15:33, Mark Brown wrote:
> On Mon, May 23, 2011 at 08:08:10PM +0800, Axel Lin wrote:
>> In the case of get_voltage callback is NULL, current implementation in
>> _regulator_get_voltage will return -EINVAL.
>>
>> Also returns proper error if ret is negative value.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
