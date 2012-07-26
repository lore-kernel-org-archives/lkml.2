Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2GZKpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:45:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2GZKpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:45:41 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Aaron Lu <aaron.lu@amd.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v3 2/7] scsi: pm: use autosuspend if device supports it
Date: Thu, 26 Jul 2012 12:44:24 +0200
Message-ID: <1476441.ovA4GKBza3@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.5.0-12-desktop+; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com> <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2012 18:05:24 Aaron Lu wrote:
> If the device is using autosuspend, when scsi_autopm_put_device is
> called for it, use autosuspend runtime pm calls instead of the sync
> call.

What is the purpose of this approach?
You need a very good reason to have an API do two different things
based on this.

	Regards
		Oliver

