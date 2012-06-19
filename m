Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2FSQcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:32:21 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:8999 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FSQcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:32:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1340123537!7172063!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jun 2012 11:32:12 -0500
Subject: RE: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options should
 be bool not tristate
Thread-Topic: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options
 should be bool not tristate
Thread-Index: Ac1N9n2ye8sPnA6fQ5GCnmCG1il0xAAQm9mw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698E76B9D@AUSP01VMBX24.collaborationhost.net>
References: <201206151520.04455.hartleys@visionengravers.com>
 <20120618235902.GA29679@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBD3D0@AUSP01VMBX24.collaborationhost.net>
 <20120619003047.GA25098@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBD3D9@AUSP01VMBX24.collaborationhost.net>
 <4FE039CD.8070209@mev.co.uk>
In-Reply-To: <4FE039CD.8070209@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 19, 2012 1:35 AM, Ian Abbott wrote:
> On 2012-06-19 02:01, H Hartley Sweeten wrote:
>> On Monday, June 18, 2012 5:31 PM, Greg KH wrote:
>>> Below is the .config I use.  Apply your patch, and select 'y' for the
>>> different options it asks for when running 'make oldconfig' and then see
>>> the build errors.
>>
>> Ok. It looks like the patch below should fix it. Can you test it?
>>   config COMEDI_ADL_PCI7296
>>   	tristate "ADLink PCI-7296 96 ch. digital io board support"
>> +	select COMED_8255
>>   	---help---
>>   	  Enable support for ADlink PCI-7296 96 ch. digital io board support
>
> That one has a typo bug.

Ugh.. my bad.

I'll fix it and repost the entire series.

Thanks,
Hartley
