Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2ECL4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:56:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44403 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2ECL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:56:35 -0400
Message-ID: <4FA27270.5070905@cantab.net>
Date: Thu, 03 May 2012 12:56:32 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 7/8] xen/setup: Populate freed MFNs from non-RAM
 E820 entries and gaps to E820 RAM
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com> <1334596539-18172-8-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1334596539-18172-8-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/12 18:15, Konrad Rzeszutek Wilk wrote:
> 
> 
> This patch, implements the populate hypercall (XENMEM_populate_physmap)
> which increases the the domain with the same amount of pages that
> were released.

Provided the problem with the unreclaimable pages are resolved:

Acked-by: David Vrabel <david.vrabel@citrix.com>

David
