Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2KLOSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:18:46 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51629 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2KLOSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:18:43 -0500
Message-ID: <50A10540.3080005@imgtec.com>
Date: Mon, 12 Nov 2012 14:18:40 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>
Subject: Re: [RFC PATCH v1 31/31] ARC: [plat-arcfpga] defconfig
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-32-git-send-email-vgupta@synopsys.com> <201211071406.58304.arnd@arndb.de>
In-Reply-To: <201211071406.58304.arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_11_12_14_18_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/12 14:06, Arnd Bergmann wrote:
> On Wednesday 07 November 2012, Vineet Gupta wrote:
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> ---
>>  arch/arc/configs/fpga_defconfig |  607 +++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 607 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arc/configs/fpga_defconfig
>>
>> diff --git a/arch/arc/configs/fpga_defconfig b/arch/arc/configs/fpga_defconfig
>> new file mode 100644
>> index 0000000..cfdca3c
>> --- /dev/null
>> +++ b/arch/arc/configs/fpga_defconfig
>> @@ -0,0 +1,607 @@
>> +#
>> +# Automatically generated file; DO NOT EDIT.
>> +# Linux/arc 3.7.0-rc3 Kernel Configuration
>> +#
> 
> Please use "make defconfig" to generate minimal defconfig files, instead of
> copying the entire file here.

Hi Arnd,

I think you mean "make savedefconfig"? (I think "make defconfig" loads
the default defconfig).

Cheers
James

