Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2DMHhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 03:37:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2DMHhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 03:37:52 -0400
Date: Fri, 13 Apr 2012 08:37:45 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: Re: [PATCH 1/1] ata_piix: defer disks to the Hyper-V paravirtualised
 drivers by default
Message-ID: <20120413073745.GN3357@shadowen.org>
References: <1333042130-9634-1-git-send-email-apw@canonical.com>
 <4F87351E.9040905@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F87351E.9040905@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:03:42PM -0400, Jeff Garzik wrote:

> Platform quirks should be handled in piix_init_one, not with this
> haphazard read_id callback.  If prefer_ms_hyperv &&
> hypervisor-detected, then set ATA_HOST_IGNORE_ATA flag or similar.

That does sound better.  I'll whip something up.

-apw
