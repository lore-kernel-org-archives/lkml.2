Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1DZOCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:02:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58642 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab1DZOCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:02:53 -0400
Message-ID: <4DB6D085.9000204@ti.com>
Date: Tue, 26 Apr 2011 15:02:45 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 1/4] MFD: TPS65910: Add new mfd device for TPS65910
References: <DFDB2D0D-E7B1-4E1E-A3CC-D61052D42E54@slimlogic.co.uk> <20110426140001.GA3175@sortiz-mobl>
In-Reply-To: <20110426140001.GA3175@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/11 15:00, Samuel Ortiz wrote:
> Hi Jorge,
> 
> On Thu, Apr 21, 2011 at 09:35:43AM -0500, Jorge Eduardo Candelaria wrote:
>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>
>> The TPS65910 chip is a power management IC for multimedia and handheld
>> devices. It contains the following components:
> The patch looks mostly good to me.
> You may want to add a locked tps65910_set|clear_bits() API, since it seems
> you're doing many read(reg), write(reg) sequences in the GPIO driver. That
> could also be directly used by the regulator one.
> 

Samuel, I could all take this series via regulator after the fixes if that's OK with you ?

Regards

Liam

