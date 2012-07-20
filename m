Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2GTADq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:03:46 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:53042 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2GTADp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:03:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1342742623!23886892!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Thu, 19 Jul 2012 19:03:41 -0500
Subject: RE: [PATCH 00/90] staging: comedi: cleanup the pci_dev usage
Thread-Topic: [PATCH 00/90] staging: comedi: cleanup the pci_dev usage
Thread-Index: Ac1mCbe5q2ijbjHjTkeD21JFifE+fwAATHmw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA9165C3@AUSP01VMBX24.collaborationhost.net>
References: <201207181823.21230.hartleys@visionengravers.com>
 <20120719235321.GA13482@kroah.com>
In-Reply-To: <20120719235321.GA13482@kroah.com>
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

On Thursday, July 19, 2012 4:53 PM, Greg KH wrote:
> On Wed, Jul 18, 2012 at 06:23:20PM -0700, H Hartley Sweeten wrote:
>> All the comedi pci drivers currently store a pointer to the pci_dev
>> in their private data. We can use the 'struct device *hw_dev' variable
>> in the comedi_device struct instead and introduce a wrapper for
>> to_pci_dev() to allow the drivers to easily get the pci_dev.
>> 
>> This patchset does just that. It also removes the private data from
>> the drivers that no longer needed it.
>> 
>> Some of the drivers required a bit of cleanup to their "find pci device"
>> code or the private data in order to make the conversion cleaner.
>> 
>> There are still a couple drivers, specifically the ni and addi ones,
>> that need additional work before they can be converted cleanly.
>
> I've applied all of these (with the updated 01/90 patch).  Can you
> please send follow-on patches to resolve the issues that Ian pointed
> out?

Thanks! I was a bit worried about having to repost the whole set
again. ;-)

I'm working on the issues now. You should see it tomorrow.

Regards,
Hartley

