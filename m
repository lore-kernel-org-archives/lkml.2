Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0DHVyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:54:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab0DHVyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:54:07 -0400
Subject: Re: [PATCH 1/3 ] SCSI: Support several features in arcmsr driver
From: James Bottomley <James.Bottomley@suse.de>
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1C89D804FCDA41259DEBE60429B71A63@areca4e4f859d4>
References: <1C89D804FCDA41259DEBE60429B71A63@areca4e4f859d4>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 17:53:58 -0400
Message-ID: <1270763638.2837.148.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 12:01 +0800, Nick Cheng wrote:
> 1. To support instantaneous report for SCSU device change by periodic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus reset
> 4. To support HW reset in bus reset error handler

Next time, one patch per feature, please ...

I still need you to redo this one (and the SCSI reset one) in a non word
wrapped format so they can be applied ... just do an attachment since
getting outlook to attach patches inline seems to be close to
impossible.

James


