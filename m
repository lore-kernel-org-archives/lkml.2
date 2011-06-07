Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab1FGXHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:07:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:14307 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1FGXHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="10414807"
Message-ID: <4DEEAF25.5040104@intel.com>
Date: Tue, 07 Jun 2011 16:07:17 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/5] Avoid section type conflict in dma/ioat/dma_v3.c
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org> <1307485593-27196-5-git-send-email-andi@firstfloor.org>
In-Reply-To: <1307485593-27196-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/2011 3:26 PM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>
> const __read_mostly is not legal and causes section type conflicts.
> That's because the read.mostly section is not read only.
> Simply drop the const for the read mostly fields.
>
> Cc: dan.j.williams@intel.com

Acked-by: Dan Williams <dan.j.williams@intel.com>

I don't have any other ioatdma stuff pending so I'm happy for this to go 
in through another tree.

--
Dan
