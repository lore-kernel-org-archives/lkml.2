Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2GJRkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:40:06 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:22017 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2GJRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:40:04 -0400
Message-ID: <1341941787.16730.798.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: IgorMammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org
Date: Tue, 10 Jul 2012 11:36:27 -0600
In-Reply-To: <loom.20120710T132300-88@post.gmane.org>
References: <16070.2632544146$1340981518@news.gmane.org>
	 <loom.20120710T132300-88@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 11:29 +0000, IgorMammedov wrote:
> <y <at> domain.invalid> writes:
> 
> > 
> > From: Toshi Kani <toshi.kani <at> hp.com>
> > 
> > Added CPU hot-remove support through an ACPI eject notification.
> > It calls acpi_bus_hot_remove_device(), which shares the same code
> > path with the sysfs eject operation.  acpi_os_hotplug_execute()
> > serializes hot-remove operations between ACPI hot-remove and sysfs
> > eject requests.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani <at> hp.com>
> > 
> > ---
> > This patch applies on top of the patchset below.
> > 
> > [PATCH v6 0/6] ACPI: Add _OST support for ACPI hotplug
> > http://marc.info/?l=linux-acpi&m=134074381322973&w=2
> > 
> Hi Toshi,
> 
> Tested patches on RHEL6.3, ejected cpu is removed from sysfs and corresponding
> _EJxx method is called  as expected upon receiving notify with eject request.
> 
> Tested-by: IgorMammedov <imammedo@redhat.com>

Great! Thanks Igor for testing it!

-Toshi



