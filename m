Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab2FUPkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:40:42 -0400
Received: from mga06.intel.com ([134.134.136.21]:61267 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759500Ab2FUPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:40:40 -0400
MIME-Version: 1.0
In-Reply-To: <1340260626.24067.4.camel@minggr>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	<1340000766-129148-3-git-send-email-ming.m.lin@intel.com>
	<CAA9_cmcX2pajewz1v864Ni2Z3XAy8UrCRg+mg3Y2qFEd2j=nDg@mail.gmail.com>
	<1340242002.20081.84.camel@minggr>
	<CAA9_cmfCVTWtqfDY4PAzK_yaVWXLV+oMO1qt_AtQKp2upPUX=Q@mail.gmail.com>
	<1340260626.24067.4.camel@minggr>
Date: Thu, 21 Jun 2012 08:40:15 -0700
Message-ID: <CABE8wwtDDip2ZY63JPz9J3iJUk6goL6eAHskNAWkLaBp+QcyCg@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] libata: bind the Linux device tree to the ACPI
 device tree
From: Dan Williams <dan.j.williams@intel.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 11:37 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Good idea.
>
> Below is the incremental patch on top of this series.
>

Looks good, I like your additional change to pass a sdev to
ata_acpi_bind_device.

--
Dan
