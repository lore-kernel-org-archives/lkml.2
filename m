Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab0FSSA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 14:00:27 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38099 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756505Ab0FSSAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 14:00:24 -0400
Message-ID: <4C1D0587.7030308@metafoo.de>
Date: Sat, 19 Jun 2010 19:59:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH v3] hwmon: Add JZ4740 ADC driver
References: <1276924111-11158-24-git-send-email-lars@metafoo.de>        <1276958820-8862-1-git-send-email-lars@metafoo.de> <20100619182410.171856ae@hyperion.delvare>
In-Reply-To: <20100619182410.171856ae@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Jean Delvare wrote:
> Hi Lars-Peter,
>
> On Sat, 19 Jun 2010 16:47:00 +0200, Lars-Peter Clausen wrote:
>   
>> This patch adds support for reading the ADCIN pin of ADC unit on JZ4740 SoCs.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Cc: lm-sensors@lm-sensors.org
>>
>> --
>> Changes since v1
>> - Move ADC core access synchronizing from the HWMON driver to a MFD driver. The
>>   ADC driver now only reads the adcin value.
>> Changes since v2
>> - Add name sysfs attribute
>> - Report adcin in value in millivolts
>>     
>
> Changes look good. A few more comments below; other than these, your
> driver look good, and I can add it to my hwmon tree and schedule it for
> 2.6.36 if you want.
>   
Great thanks :)
As written in the introduction mail to this thread it would be good if
the majority of the patches could go through Ralfs tree. So if you don't
see any problems doing this, it would be nice if you could give your
Acked-By once I sent a updated patch.

- Lars
