Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab1BDKGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:06:46 -0500
Received: from www.tglx.de ([62.245.132.106]:56312 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1BDKGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:06:44 -0500
Message-ID: <4D4BCF99.2000108@linutronix.de>
Date: Fri, 04 Feb 2011 11:06:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Gibson <david@gibson.dropbear.id.au>, linux-kernel@vger.kernel.org,
        sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org
Subject: Re: [PATCH TIP v2 03/14] x86/dtb: Add a device tree for CE4100
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-4-git-send-email-bigeasy@linutronix.de> <20110127050027.GB23443@yookeroo> <20110202185841.GA28674@www.tglx.de> <20110203210746.GI6180@angua.secretlab.ca>
In-Reply-To: <20110203210746.GI6180@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> You can go ahead and keep the revision history above the s-o-b and ---
> lines.  It turns out that having the revision history in the commit
> text is actually useful when trying to figure out what version of a
> patch actually got applied.
Okay.

>> diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
>> new file mode 100644
>> index 0000000..e888657
>> --- /dev/null
>> +++ b/arch/x86/platform/ce4100/falconfalls.dts
>> @@ -0,0 +1,424 @@

>> +	soc@0 {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		compatible = "intel,ce4100-cp";
> 
> You'll need to add blurbs to Documentation/devicetree/bindings
> (Documentation/powerpc/dts-bindings in Linus' tree; renamed in
> linux-next) for each of these new compatible bindings to document the
> part that they describe and any special properties that go with each
> compatible value (if any).  You can send it as a followup patch.

Good point, will do.

>> +				gpio@b,1 {
>> +					compatible = "pci8086,2e67.2",
>> +						   "pci8086,2e67",
>> +						   "pciclassff0000",
>> +						   "pciclassff00";
>> +
>> +					reg = <0x15900 0x0 0x0 0x0 0x0>;
>> +					interrupts = <15 1>;
>> +				};
> 
> You'll probably want to make use of the gpio-controller binding for
> the gpio nodes so that other nodes can reference it.  Not a
> showstopper for this patch though.

Right. I'll make it follow-up once I get to the gpio functionality.

> Otherwise looks good to me.
thanks.

> g.

Sebastian
