Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0I2SCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:02:08 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:36473 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0I2SCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:02:07 -0400
Date: Wed, 29 Sep 2010 14:01:55 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH -v2 1/5] ACPI, APEI, Fix APEI related table size checking
In-reply-to: <1285761235-4751-2-git-send-email-ying.huang@intel.com>
Message-id: <alpine.LFD.2.00.1009291400590.3855@localhost.localdomain>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
 <1285761235-4751-2-git-send-email-ying.huang@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Originally-by: Yinghai Lu <yinghai@kernel.org>

BTW.

If the patch is substantially the same as the original,
then the method to credit the original author is to
start the patch body with:

From: Yinghai Lu <yinghai@kernel.org>

and you can choose to note your changes in the signed-off part,
like akpm typically does, or not.

thanks,
Len Brown, Intel Open Source Technology Center

