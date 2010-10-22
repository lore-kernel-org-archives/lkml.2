Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0JVFu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:50:28 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:43354 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0JVFuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:50:25 -0400
Date: Fri, 22 Oct 2010 01:50:08 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/9] ACPI, APEI patches for 2.6.37
In-reply-to: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Message-id: <alpine.LFD.2.00.1010220147560.27300@localhost.localdomain>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010, Huang Ying wrote:

> [PATCH 2/9] Add lock-less version of bitmap_set/clear
> [PATCH 3/9] lock-less NULL terminated single list implementation
> [PATCH 4/9] lock-less general memory allocator

What kinds of tests has this lockless lib code been subject to?
This is generic code, does it play on multiple architectures?

thanks,
Len Brown Intel Open Source Technology Center

