Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2GQCcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:32:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:48026 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2GQCct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:32:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1342492358!8868660!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Mon, 16 Jul 2012 21:32:39 -0500
Subject: RE: [PATCH] staging: comedi: adl_pci6208: use the comedi_device
 hw_dev to hold the pci_dev
Thread-Topic: [PATCH] staging: comedi: adl_pci6208: use the comedi_device
 hw_dev to hold the pci_dev
Thread-Index: Ac1jxDGtnNhrSsG9QPquBGOOd1f36QAACPqw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA915E1C@AUSP01VMBX24.collaborationhost.net>
References: <201207161926.22725.hartleys@visionengravers.com>
 <20120717023050.GA3025@kroah.com>
In-Reply-To: <20120717023050.GA3025@kroah.com>
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

On Monday, July 16, 2012 7:31 PM, Greg KH wrote:
> On Mon, Jul 16, 2012 at 07:26:22PM -0700, H Hartley Sweeten wrote:
>> Use the 'struct device *hw_dev' variable in the comedi_device struct
>> to hold the pci_dev instead of carrying it in the private data.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/staging/comedi/drivers/adl_pci6208.c | 19 ++++++++++---------
>>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> Looks good to me, I forgot we had the to_pci_dev() macro in pci.h.  Want
> to redo all of these and resend this one with the larger series?

Will do. Should be able to get it out tomorrow.

Regards,
Hartley

