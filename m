Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2LDLoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:44:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35243 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2LDLoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:44:16 -0500
Message-ID: <50BDE224.8000301@ti.com>
Date: Tue, 4 Dec 2012 17:14:36 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory: of_memory.c: remove unnecessary initialization
References: <1354620448-14317-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1354620448-14317-1-git-send-email-dinggnu@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012 04:56 PM, Cong Ding wrote:
> the initialization of variable ret is unnecessary, we can remove it while save
> one time "or" operation.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
Looks ok.
Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>

