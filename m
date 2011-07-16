Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1GPW4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 18:56:16 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:32836 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1GPW4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 18:56:14 -0400
Date: Sat, 16 Jul 2011 18:56:11 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ACPI / Battery: avoid acpi_battery_add() use-after-free
In-reply-to: <1310457809-2731-3-git-send-email-stefanha@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1107161855590.11045@x980>
References: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <1310457809-2731-3-git-send-email-stefanha@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi-test
(on top of existing battery patches)


thanks,
Len Brown, Intel Open Source Technology Center

