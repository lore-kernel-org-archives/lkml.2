Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2ECLzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:55:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65432 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752155Ab2ECLzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:55:06 -0400
Message-ID: <4FA27212.9060403@cantab.net>
Date: Thu, 03 May 2012 12:54:58 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 6/8] xen/setup: Work properly with 'dom0_mem=X'
 or with not dom0_mem.
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com> <1334596539-18172-7-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1334596539-18172-7-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/12 18:15, Konrad Rzeszutek Wilk wrote:
> We ignored the X value and ended up populating up to
> max(MAX_DOMAIN_PAGES, last E820_RAM entry).
> 
> This fixes it by figuring out how many RAM nr_pages the
> hypervisor wanted to provide to us and cap the populate
> hypercalls up to that.

I don't think we should change the behavior again, particularly as the
dom0_mem documentation doesn't describe this proposed behaviour.

I would drop this patch.

David
