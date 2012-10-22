Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2JVCOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 22:14:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11713 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab2JVCOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 22:14:36 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-f9-5084ac0a43be
Message-id: <5084AC0A.8040608@samsung.com>
Date: Mon, 22 Oct 2012 11:14:34 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Jenny TC <jenny.tc@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] extcon : register for cable interest by cable name
References: <1350475725-8457-1-git-send-email-jenny.tc@intel.com>
In-reply-to: <1350475725-8457-1-git-send-email-jenny.tc@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQV2uNS0BBrPumlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mjwc/sxfM4Ky4equHsYHxEHsXIyeHhICJxPvu88wQtpjEhXvr
	2boYuTiEBKYzSqw8O50JwulikmhffYARpIpXQEvie+c0sG4WAVWJdZ2tYN1sQPH9L24AdXNw
	iApESPzq54AoF5T4MfkeC4gtIqAo8en0fSYQm1nAU6JvRjsbiC0s4CWx8fpWsDFCAo4SN2as
	ABvPKeAk0b1gIjNEvY7E/tZpbBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECA7AZ1I7GFc2WBxiFOBgVOLhnbGwJUCINbGsuDL3EKMEB7OSCO+p
	eKAQb0piZVVqUX58UWlOavEhRmkOFiVx3maPlAAhgfTEktTs1NSC1CKYLBMHp1QDo3XMgZj5
	z0SLEzwqaiVfLJVf9oA7dsECu6QFVmnRt//vP620ay0ng+YrJtVX1Tdq3s+bfObdEcugp+ZF
	19KPXknkXDs5V0654Y7n/CChMrNU/Xv/xHcVCEsKRk3ZnftwqvgPjQSJbyFH3aWDHzxZ+4w1
	0WHFvsWmm/ds8C49k2b60+SzUvbjBUosxRmJhlrMRcWJACxzWzs8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 09:08 PM, Jenny TC wrote:
> There are some scnearios where a driver/framework needs to register
> interest for a particular cable without specifying the extcon device
> name. One such scenario is charger notifications. The platform will
> have charger cabel which will be bound to any extcon device. It's
> not mandatory for the charger driver to know which extcon device
> it should use. This patch enables the support for registering
> interest for a cable just by cable name wihtout specifying the
> extcon device name
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
> v1:
>   Initial submit
> V2:
>   Removed the new API and modified the extcon_register_interest
>   API to accomodate the new requirement
> 
>  drivers/extcon/extcon-class.c |   43 +++++++++++++++++++++++++++++++----------
>  1 file changed, 33 insertions(+), 10 deletions(-)
> 
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>

Applied it and This patch is tested by me on charger-manager.

You can check it after some hours at extcon tree:
- http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Thanks,
Chanwoo Choi
