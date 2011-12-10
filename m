Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1LJTgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 14:36:11 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:35721 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1LJTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 14:36:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20195.46240.112741.353593@quad.stoffel.home>
Date: Sat, 10 Dec 2011 14:36:00 -0500
From: "John Stoffel" <john@stoffel.org>
To: Greg KH <greg@kroah.com>
Cc: Anand Kanaginhal <anand_dk@hotmail.com>, mjg59@srcf.ucam.org,
        bhelgaas@google.com, Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: Re: PCIe Hotplugging not working
In-Reply-To: <20111209222520.GA24786@kroah.com>
References: <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
	<20111130154022.GA1411@srcf.ucam.org>
	<BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>
	<20111130182423.GA4831@srcf.ucam.org>
	<CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>
	<BAY163-W600D6D6A04D4BAE8278907FBB90@phx.gbl>
	<20111209124524.GA3488@srcf.ucam.org>
	<BAY163-W45C53B9E3E9E0B8629B683FBB90@phx.gbl>
	<20111209180708.GA10768@kroah.com>
	<BAY163-W154A24444BB398F609767CFBB90@phx.gbl>
	<20111209222520.GA24786@kroah.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Greg" == Greg KH <greg@kroah.com> writes:

Greg> On Fri, Dec 09, 2011 at 01:17:53PM -0800, Anand Kanaginhal wrote:
>> 
>> 
>> > Date: Fri, 9 Dec 2011 10:07:08 -0800
>> > From: greg@kroah.com
>> > To: anand_dk@hotmail.com
>> > CC: mjg59@srcf.ucam.org; bhelgaas@google.com; linux-pci@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
>> > Subject: Re: PCIe Hotplugging not working
>> >
>> > On Fri, Dec 09, 2011 at 09:19:39AM -0800, Anand Kanaginhal wrote:
>> > > 1. With the above setup, If I hotplug card c1 and/or c2, will my driver
>> probe
>> > > get invoked.
>> >
>> > Stop right here. Please get your pci hotplug controller driver working
>> > first, for your platform. That seems to be the problem. After that,
>> > the rest of your questions should just resolve themselves.
>> Thank you Greg for your assistance, perhaps it would be little more helpful, if
>> you could tell me the basis on which you drew the conclusion. I am no kernel
>> expert :( 

Greg> As your driver's callbacks aren't being called, that's probably why this
Greg> isn't working.

Greg> Please make sure your pci hotplug driver is working first.  Try turning
Greg> on and off the power to the card slot (in the sysfs directory for the
Greg> slot) and see if that's working.

Greg> You also have failed to say exactly what pci hotplug controller
Greg> you have in your system, what is it?  You have to have one, and
Greg> the driver loaded for it, for any of this to work at all.


And it would make sense to test your hotplug setup with a known
working card that *does* support hotplugging properly already.  Then
you know your setup works and you can then concentrate on getting your
new card working.  

John
