Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2KLXQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:16:29 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34096 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2KLXQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:16:28 -0500
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206B258868B@AUSP01VMBX24.collaborationhost.net>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
 <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com> <ADE657CA350FB648AAC2C43247A983F00206B258868B@AUSP01VMBX24.collaborationhost.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Nov 2012 16:16:06 -0700
Message-ID: <CAErSpo7Y+SSAbZ_eA9K6TqymvZ77YZ1kh9nstTDaW258wYUJ-Q@mail.gmail.com>
Subject: Re: Q: Kconfig option VIRT_TO_BUS
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 4:13 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Monday, November 12, 2012 11:41 AM, Bjorn Helgaas wrote:
>> On Mon, Nov 12, 2012 at 9:18 AM, H Hartley Sweeten wrote:
>>> Does anyone know what the Kconfig option VIRT_TO_BUS does?
>>> There are a number of "depends on" that option but it does not
>>> seem to directly enable any code in the kernel.
>>
>> virt_to_bus() is a deprecated interface for converting a kernel
>> virtual address to a bus address.  It's deprecated because it's
>> impossible to implement correctly when there are multiple bus address
>> spaces, because you don't know which bus address space the caller has
>> in mind.
>
> Thanks for the info.
>
> So if a driver does not use virt_to_bus() then the "depends on VIRT_TO_BUS"
> is not necessary. Correct?

Yes, that's my understanding.
