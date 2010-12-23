Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab0LWUwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 15:52:15 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:50456 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752201Ab0LWUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 15:52:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=X62QN26qLdaCWW84ebpM0idFexWGqnLxrk7GuYKWQH/K/enmA+pjkSJAQCECqe876HLbkajAPqIJYNF6+a+X9u0VkmDXo56K9mTz3ECB0ZijS9bID6ZeglWSB1p/52s4;
Date: Thu, 23 Dec 2010 12:52:10 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Resend][PATCH] PCI / Hotplug: Fix unexpected driver unregister
 in pciehp_acpi.c
Message-ID: <20101223125210.07cc350f@jbarnes-desktop>
In-Reply-To: <4D0EA38C.2090003@jp.fujitsu.com>
References: <201012181329.46071.rjw@sisk.pl>
	<4D0EA38C.2090003@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 09:30:04 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> (2010/12/18 21:29), Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki<rjw@sisk.pl>
> > 
> > If pcie_ports_disabled is set, pcie_port_service_register() returns
> > error code and select_detection_mode() should not attempt to
> > unregister dummy_driver and use dummy_slots.  It should return
> > PCIEHP_DETECT_ACPI immediately instead.
> > 
> > Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> 
> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> 

Applied to my for-linus branch, thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
