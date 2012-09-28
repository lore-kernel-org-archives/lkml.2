Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2I1Ncb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:32:31 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:40051 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758200Ab2I1Nc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120928130240.GN31006@arwen.pp.htv.fi>
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
	<1348836795-4783-7-git-send-email-kishon@ti.com>
	<20120928130240.GN31006@arwen.pp.htv.fi>
Date: Fri, 28 Sep 2012 19:02:26 +0530
Message-ID: <CAAe_U6Lu-bKXEA7ZUHMiS3R+e6eZ+NEg3VTT+RmepqwqyYYmOA@mail.gmail.com>
Subject: Re: [PATCH 6/6] usb: dwc3: core: add dt support for dwc3 core
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 28, 2012 at 6:32 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Sep 28, 2012 at 06:23:15PM +0530, Kishon Vijay Abraham I wrote:
>> Added dwc3 support for dwc3 core and update the documentation with
>> device tree binding information.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  Documentation/devicetree/bindings/usb/dwc3.txt |   24 ++++++++++++++++++++++++
>>  drivers/usb/dwc3/core.c                        |   14 ++++++++++++--
>>  2 files changed, 36 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt
>>
>> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
>> new file mode 100644
>> index 0000000..87d5eeb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
>> @@ -0,0 +1,24 @@
>> +SYNOPSIS DWC3 CORE
>> +
>> +DWC3- USB3 CONTROLLER
>> +
>> +Required properties:
>> + - compatible: Should be "synopsis,dwc3"
>
> "synopsys" and I think:
>
> - compatible: Must be "synopsys,dwc3" reads a bit better.

Will re-post this patch.

Thanks
Kishon
