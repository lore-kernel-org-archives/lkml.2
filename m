Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab2KMS7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:59:13 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44681 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab2KMS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:59:08 -0500
MIME-Version: 1.0
In-Reply-To: <1352249879-11406-1-git-send-email-ying.huang@intel.com>
References: <1352249879-11406-1-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Nov 2012 11:58:44 -0700
Message-ID: <CAErSpo6LqWfXd3NY2pDsE0RmWNKApyF+Lbv8_Bvq3ULMuy7Bvw@mail.gmail.com>
Subject: Re: [PATCH -v2] ACPI/PCI: Make PCI devices notified when its power
 resource turned on
To: Huang Ying <ying.huang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 5:57 PM, Huang Ying <ying.huang@intel.com> wrote:
> A set of power resources may be shared by multiple devices.  When all
> devices share one set of power resources is put into D3_COLD state,
> the power resources will be turned off.  When one of the device is
> waked, the power resource will be turned on and all devices share it
> will be powered on to D0uninitialized state.  These devices should be
> resumed, so that they can get opportunity to go to low power state
> later.
>
> v2:
>
> - Fix build error
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/acpi/pci_bind.c |    2 ++
>  1 file changed, 2 insertions(+)

I applied this to my pci/misc branch as v3.8 material.  Thanks!

Bjorn
