Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1AGW2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:28:37 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:37274 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754143Ab1AGW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:28:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oc7nQIcvcC46dxcVEvtgm4QBwIwQbjksZwpOHIxsU5dtuTU38/jBit0G7lczIqYTuRvgIVBps9Fgn99TUwwUAINVDalyxfD/EwN13u7MqCdnJBakCMRoD7zat8KJblQs;
Date: Fri, 7 Jan 2011 14:28:32 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: [Resend][PATCH] PCI / ACPI: Request _OSC control once for each
 root bridge (v3)
Message-ID: <20110107142832.5f4f1ae5@jbarnes-desktop>
In-Reply-To: <201101070055.10065.rjw@sisk.pl>
References: <201101070055.10065.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011 00:55:09 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move the evaluation of acpi_pci_osc_control_set() (to request control
> of PCI Express native features) into acpi_pci_root_add() to avoid
> calling it many times for the same root complex with the same
> arguments.  Additionally, check if all of the requisite _OSC
> support bits are set before calling acpi_pci_osc_control_set() for
> a given root complex.
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=20232
> Reported-by: Ozan Caglayan <ozan@pardus.org.tr>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Hi,
> 
> This fixes a post-2.6.35 regression for Ozan, possibly -stable material.
> 

Applied, thanks, but I forgot the cc: stable, so please send the commit
id to stable@ once it lands in Linus's tree, if you still think it's
appropriate.

-- 
Jesse Barnes, Intel Open Source Technology Center
