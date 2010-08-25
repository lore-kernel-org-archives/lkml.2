Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0HYU5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:57:14 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:38702 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0HYU5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:57:11 -0400
Date: Wed, 25 Aug 2010 16:56:53 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 8/8] ideapad: Change the driver name to ideapad_laptop
In-reply-to: <1282120734-11635-1-git-send-email-ike.pan@canonical.com>
Message-id: <alpine.LFD.2.00.1008251656090.3037@localhost.localdomain>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
 <1282120734-11635-1-git-send-email-ike.pan@canonical.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  drivers/platform/x86/ideapad_acpi.c   |  381 ---------------------------------
>  drivers/platform/x86/ideapad_laptop.c |  381 +++++++++++++++++++++++++++++++++

Acked-by: Len Brown <len.brown@intel.com>

thanks,
Len Brown, Intel Open Source Technology Center

