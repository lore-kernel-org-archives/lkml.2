Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab2HFEve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:51:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33806 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2HFEvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:51:32 -0400
Message-ID: <501F4D51.9070306@gmail.com>
Date: Sun, 05 Aug 2012 22:51:29 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] intel-iommu: Fix ACS path checking
References: <20120804180155.6144.83332.stgit@bling.home> <20120804180852.6144.71902.stgit@bling.home>
In-Reply-To: <20120804180852.6144.71902.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/12 12:08 PM, Alex Williamson wrote:
> SR-IOV can create buses without a bridge.  There may be other cases
> where this happens as well.  In these cases skip to the parent bus
> and continue testing devices there.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Tested-by: David Ahern <dsahern@gmail.com>

