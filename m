Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2IMPhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:37:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57940 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab2IMPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:37:28 -0400
Message-ID: <5051FDB3.9040008@wwwdotorg.org>
Date: Thu, 13 Sep 2012 09:37:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <2689722.93BQTh4lSC@percival> <1347519249.7471.42.camel@lappyti> <3082244.Oec3ulPCgi@percival>
In-Reply-To: <3082244.Oec3ulPCgi@percival>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 01:08 AM, Alex Courbot wrote:
> On Thursday 13 September 2012 14:54:09 Tomi Valkeinen wrote:
>> * PGP Signed by an unknown key
>>
>> On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
>>
>>> On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
>>>
>>>  
>>>  
>>>> However, I fear these board specific things may be quite a bit
>>>> anything,
>>>> so it may well be pwm, gpios and regulators are not enough for them.
>>>> For
>>>> example, there could be an FPGA on the board which requires some
>>>> configuration to accomplish the task at hand. It could be rather
>>>> difficult to handle it with a generic power sequence.
>>>
>>>
>>> Right. Note that this framework is supposed to be extended - I would like
>>> to at least add regulator voltage setting, and maybe even support for
>>> clocks and pinmux (but that might be out of place).
>>
>>
>> Yes, that's one concern of mine... I already can imagine someone
>> suggesting adding conditionals to the power sequence data.
> 
> I took care of that when naming the feature - it is not a "sequence" anymore 
> if you have conditionals. :P
> 
>> Perhaps also
>> direct memory read/writes so you can twiddle registers directly. And so
>> on. Where's the limit what it should contain? Can we soon write full
>> drivers with the DT data? =)
> 
> I shall be satisfied the day the kernel is released as one big DT node along 
> with the 5KB interpreter that runs it.

I know you're joking, but *cough* OpenFirmware *cough*, right?
