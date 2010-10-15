Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0JOOL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:11:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8316 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0JOOL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:11:26 -0400
X-IronPort-AV: E=Sophos;i="4.57,336,1283731200"; 
   d="scan'208";a="2364718"
Date: Fri, 15 Oct 2010 15:11:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH v4 4/7] acpi: use indirect call to register gsi in
 different modes
In-Reply-To: <201010142332.35224.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1010151510260.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop> <1286901289-8156-4-git-send-email-stefano.stabellini@eu.citrix.com> <201010142332.35224.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Rafael J. Wysocki wrote:
> On Tuesday, October 12, 2010, stefano.stabellini@eu.citrix.com wrote:
> > From: Jeremy Fitzhardinge <jeremy@goop.org>
> > 
> > Rather than using a tree of conditionals, use function pointer
> > for acpi_register_gsi.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Looks good to me.
> 

Thank you very much for taking the time to read these two patches!

