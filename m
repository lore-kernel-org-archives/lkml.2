Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1BISAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:00:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:59711 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab1BISAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:00:15 -0500
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
From: James Bottomley <James.Bottomley@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201102091515.16202.bzolnier@gmail.com>
References: <201102091515.16202.bzolnier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 12:00:08 -0600
Message-ID: <1297274408.3016.29.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 15:15 +0100, Bartlomiej Zolnierkiewicz wrote:
> Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
> config option) to allow disabling of scsi_devinfo infrastructure.
> 
> The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=n
> (as measured on x86-32):

I don't understand the point of this patch ... without the quirks SCSI
will do the wrong thing on a whole bunch of stuff.  The savings look to
be tiny ... since the SCSI module is habitually a lot larger than your
figures suggest.

James


