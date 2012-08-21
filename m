Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2HUAuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 20:50:11 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:34985 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2HUAuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 20:50:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1345510203!7536868!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 20 Aug 2012 19:50:02 -0500
Subject: RE: [PATCH 09/20] staging: comedi: adv_pci1723: fix initial dio
 subdevice state and io_bits
Thread-Topic: [PATCH 09/20] staging: comedi: adv_pci1723: fix initial dio
 subdevice state and io_bits
Thread-Index: Ac1/Ha2Fdu9JQb+7SKiZ02GflO7ELgAABPFwAASE+yA=
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AFA33B20@AUSP01VMBX24.collaborationhost.net>
References: <201208171817.38918.hartleys@visionengravers.com>
 <20120820214916.GA11795@mwanda>
 <ADE657CA350FB648AAC2C43247A983F00206AAFDC467@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AAFDC467@AUSP01VMBX24.collaborationhost.net>
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

On Monday, August 20, 2012 2:51 PM, H Hartley Sweeten wrote:
> On Monday, August 20, 2012 2:49 PM, Dan Carpenter wrote:
>> On Fri, Aug 17, 2012 at 06:17:38PM -0700, H Hartley Sweeten wrote:
>>> +	if (this_board->n_diochan) {
>>> +		s = dev->subdevices + subdev;
>>
>> This pointer math sucks still...  I feel like the unreadable code is
>> part of what caused this bug.
>>
>> We don't have to change these all at once.  If we fix only one line,
>> then at least one line will be readable and that is one more than
>> before so *improvement*.
>
> Hello Dan,
>
> I'll work of changing the pointer math to array access.
>
> I'll try to post a big chunk of them today.
>

Dan,

I just posted a patch that changes all the pointer math for the
comedi_subdevice to array access.

It's based on top of the changes I have already posted for the
comedi subsystem. As long as Greg doesn't find any issues with
those, this patch should apply cleanly.

If I need to I will rebase it.

Regards,
Hartley

