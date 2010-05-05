Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab0EEUfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:35:12 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:52406 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab0EEUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:35:09 -0400
Date: Wed, 05 May 2010 16:34:50 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alex Chiang <achiang@canonical.com>
Cc: colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple Lenovo
 ThinkPads
In-reply-to: <20100420140314.GA5573@canonical.com>
Message-id: <alpine.LFD.2.00.1005051634180.23230@localhost.localdomain>
References: <20100420140314.GA5573@canonical.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied for 2.6.34 (and acked for .stable)

hopefully we'll figure out how to safely nuke this DMI list shortly.

thanks,
Len Brown, Intel Open Source Technology Center

