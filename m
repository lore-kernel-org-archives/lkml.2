Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2JIQVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:21:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48572 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2JIQVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:21:09 -0400
Message-ID: <50744EF1.6090609@wwwdotorg.org>
Date: Tue, 09 Oct 2012 10:21:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/4] regulator: tps65090: add external control support
 for DCDC
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com> <1349776142-6409-5-git-send-email-ldewangan@nvidia.com> <D958900912E20642BCBC71664EFECE3E6DDF8AF6F1@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDF8AF6F1@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 04:33 AM, Venu Byravarasu wrote:
> Laxman Dewangan wrote at Tuesday, October 09, 2012 3:19 PM:
>> The TPS65090's DCDC output can also be enable/disable through the
>> external digital input signal. Add support for enable/disable
>> either through register access via I2C or through external
>> control inputs. The external control inputs can be driven through
>> GPIOs also and hence adding support for passing the GPIO number.

>> -static struct regulator_ops tps65090_ops = {
>> -	.enable = regulator_enable_regmap,
>> -	.disable = regulator_disable_regmap,
>> -	.is_enabled = regulator_is_enabled_regmap,
>> +static struct regulator_ops tps65090_ext_control_ops = {
>> +};
> 
> What is the purpose of adding empty structure?

When replying to a patch (or email in general), it's usually a good idea
to delete stuff that you're not replying to. Otherwise, it can be hard
to find the replies since they're buried in a huge long email.
