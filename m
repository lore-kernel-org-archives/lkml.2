Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1LGRXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:23:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab1LGRXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:23:49 -0500
MIME-Version: 1.0
In-Reply-To: <20111130182423.GA4831@srcf.ucam.org>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl> <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
 <20111130154022.GA1411@srcf.ucam.org> <BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>
 <20111130182423.GA4831@srcf.ucam.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 Dec 2011 10:23:26 -0700
Message-ID: <CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>
Subject: Re: PCIe Hotplugging not working
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Anand Kanaginhal <anand_dk@hotmail.com>, greg@kroah.com,
        Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 11:24 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Nov 30, 2011 at 09:18:39AM -0800, Anand Kanaginhal wrote:
>>
>> Hi Mathew,
>> I have following options set
>>
>> CONFIG_HOTPLUG_PCI_PCIE=y
>> CONFIG_HOTPLUG_PCI_ACPI=m
>
> Please try with this built in, not as a module. What kind of board are
> you using?

Is this resolved?  If not, a complete dmesg log would be interesting.
You might also try current upstream in case there were relevant
changes since 2.6.38.12.
