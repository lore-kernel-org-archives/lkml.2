Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2BPKGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:06:17 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:42990 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab2BPKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:06:14 -0500
Message-ID: <4F3CD511.6030409@ti.com>
Date: Thu, 16 Feb 2012 15:36:09 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Aneesh V <aneesh@ti.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 2/8] misc: ddr: add LPDDR2 data from JESD209-2
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-3-git-send-email-aneesh@ti.com>
In-Reply-To: <1328357771-31644-3-git-send-email-aneesh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
> add LPDDR2 data from the JEDEC spec JESD209-2. The data
> includes:
> 
> 1. Addressing information for LPDDR2 memories of different
>    densities and types(S2/S4)
> 2. AC timing data.
> 
> This data will useful for memory controller device drivers
> 
> Signed-off-by: Aneesh V <aneesh@ti.com>
Looks good to me.

Regards
santosh
