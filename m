Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2FYTWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:22:07 -0400
Received: from mga12.intel.com ([143.182.124.36]:46996 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203Ab2FYTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:22:04 -0400
MIME-Version: 1.0
In-Reply-To: <1340611992-41457-3-git-send-email-ming.m.lin@intel.com>
References: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
	<1340611992-41457-3-git-send-email-ming.m.lin@intel.com>
Date: Mon, 25 Jun 2012 12:22:01 -0700
Message-ID: <CABE8wwsj+LOpgWE2f==n38OGJwWDoGbFk7pEsL9g3vP599KVGg@mail.gmail.com>
Subject: Re: [PATCH v6 02/11] libata: bind the Linux device tree to the ACPI
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

On Mon, Jun 25, 2012 at 1:13 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> From: Matthew Garrett <mjg@redhat.com>
>
> Associate the ACPI device tree and libata devices.
> This patch uses the generic ACPI glue framework to do so.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Holger Macht <holger@homac.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
