Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2CMUr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:47:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41759 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2CMUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:47:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6648"; a="172162067"
Date: Tue, 13 Mar 2012 13:47:10 -0700
From: David Brown <davidb@codeaurora.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dave.martin@linaro.org, nicolas.pitre@linaro.org,
        catalin.marinas@arm.com, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] arm: Add unwinding support for memset and memzero.
Message-ID: <20120313204710.GA1772@codeaurora.org>
References: <1331574027-28542-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331574027-28542-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:40:27AM -0700, Laura Abbott wrote:
> @@ -41,7 +43,7 @@ ENTRY(memset)
>  	blt	4f
>  
>  #if ! CALGN(1)+0
> -
> +UNWIND(.save {lr})
>  /*
>   * We need an extra register for this loop - save the return address and
>   * use the LR

Did you intend to remove these blank lines?

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
