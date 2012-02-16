Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab2BPKqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:46:08 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:39555 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab2BPKqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:46:06 -0500
Message-ID: <4F3CDE68.6000501@ti.com>
Date: Thu, 16 Feb 2012 16:16:00 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Aneesh V <aneesh@ti.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 8/8] misc: emif: add debugfs entries for emif
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-9-git-send-email-aneesh@ti.com>
In-Reply-To: <1328357771-31644-9-git-send-email-aneesh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
> Add debug entries for:
> 	1. calculated registers per frequency
> 	2. last polled value of MR4(temperature level
> 	   of LPDDR2 memory)
> 
> Signed-off-by: Aneesh V <aneesh@ti.com>

looks good.

Regards
santosh
