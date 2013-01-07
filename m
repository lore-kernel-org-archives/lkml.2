Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3AGJTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:19:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3AGJTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:19:36 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v6 4/4] sd: change to auto suspend mode
Date: Mon, 07 Jan 2013 10:19:31 +0100
Message-ID: <2040976.slu5Ii8g67@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1357461697-4219-5-git-send-email-aaron.lu@intel.com>
References: <1357461697-4219-1-git-send-email-aaron.lu@intel.com> <1357461697-4219-5-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2013 16:41:37 Aaron Lu wrote:
> From: Lin Ming <ming.m.lin@intel.com>
> 
> Uses block layer runtime pm helper functions in
> scsi_runtime_suspend/resume.
> Remove scsi_autopm_* from sd open/release path and check_events path.
> And remove the quiesce call in runtime suspend path, as we know there is
> no request to quiesce for the device.

How does this handle ioctl() ?

	Regards
		Oliver

