Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2KLXN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:13:57 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:19837 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2KLXNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:13:55 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1352762034!11910074!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 12 Nov 2012 17:13:52 -0600
Subject: RE: Q: Kconfig option VIRT_TO_BUS
Thread-Topic: Q: Kconfig option VIRT_TO_BUS
Thread-Index: Ac3BBUzmbt8PdCmHQNC0fHLCsBwJ2gAJd2UA
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B258868B@AUSP01VMBX24.collaborationhost.net>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
 <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
In-Reply-To: <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
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

On Monday, November 12, 2012 11:41 AM, Bjorn Helgaas wrote:
> On Mon, Nov 12, 2012 at 9:18 AM, H Hartley Sweeten wrote:
>> Does anyone know what the Kconfig option VIRT_TO_BUS does?
>> There are a number of "depends on" that option but it does not
>> seem to directly enable any code in the kernel.
>
> virt_to_bus() is a deprecated interface for converting a kernel
> virtual address to a bus address.  It's deprecated because it's
> impossible to implement correctly when there are multiple bus address
> spaces, because you don't know which bus address space the caller has
> in mind.

Thanks for the info.

So if a driver does not use virt_to_bus() then the "depends on VIRT_TO_BUS" 
is not necessary. Correct?

Thanks,
Hartley
