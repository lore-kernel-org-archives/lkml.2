Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2FTSA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:00:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46395 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2FTSA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:00:27 -0400
Message-ID: <4FE20FB8.1020601@wwwdotorg.org>
Date: Wed, 20 Jun 2012 12:00:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: export of_platform_populate()
References: <1339113456-27089-1-git-send-email-swarren@wwwdotorg.org> <4FD60030.8090700@gmail.com>
In-Reply-To: <4FD60030.8090700@gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 08:26 AM, Rob Herring wrote:
> On 06/07/2012 06:57 PM, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Without this, modules can't use this API, leading to build failures.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
> 
> Applied for 3.5.

Thanks.

Do you know when it will show up in linux-next and/or 3.5 itself? The
patch hasn't rebased out of my local tree yet.
