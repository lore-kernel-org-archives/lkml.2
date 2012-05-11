Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab2EKSSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:18:47 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37882 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2EKSSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:18:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1336760322!5244076!9
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Date: Fri, 11 May 2012 13:18:42 -0500
Subject: RE: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
Thread-Topic: [PATCH] staging: comedi: Add helper macro for comedi pci
 driver boilerplate
Thread-Index: Ac0vof4R6hHR4fElSHqm3qlkc4OL9QAAGkIA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17EC1@AUSP01VMBX24.collaborationhost.net>
References: <201205111007.46754.hartleys@visionengravers.com>
 <20120511175954.GA7920@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A17EA9@AUSP01VMBX24.collaborationhost.net>
 <4FAD5723.1060405@mev.co.uk>
In-Reply-To: <4FAD5723.1060405@mev.co.uk>
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

On Friday, May 11, 2012 11:15 AM, Ian Abbott wrote:
> On 2012-05-11 19:04, H Hartley Sweeten wrote:
>> On Friday, May 11, 2012 11:00 AM, Greg KH wrote:
>>> On Fri, May 11, 2012 at 10:07:43AM -0700, H Hartley Sweeten wrote:
>>>> +EXPORT_SYMBOL(comedi_pci_driver_unregister);
>>>
>>> EXPORT_SYMBOL_GPL() for these two functions?
>>
>> I wasn't sure about that...
>>
>> Question.. when "should" EXPORT_SYMBOL be used and
>> when should it be EXPORT_SYMBOL_GPL?
>
> Adding EXPORT_SYMBOL_GPL shouldn't remove previous functionality.  It 
> doesn't in this case, so that's okay!

OK. I'll change it.

Regards,
Hartley

