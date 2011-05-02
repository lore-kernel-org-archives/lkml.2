Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1EBRbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:31:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40343 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1EBRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:31:33 -0400
Message-ID: <4DBEEA69.7010000@zytor.com>
Date: Mon, 02 May 2011 10:31:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        yinghai@kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] Two patches fixing regression introduced by 'x86-64,
 mm: Put early page table high'
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 10:22 AM, Konrad Rzeszutek Wilk wrote:
> 
> But we haven't come up with an acceptable general solution yet, so this
> patchset provides a workaround for the problem. Peter, Yinghai - what would be
> the best forum/email/conference to hammer out a general solution for this?
> 
> Currently, there are couple of ways of fixing this:
>  - use pvops hooks: http://marc.info/?i=1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com
>  - have a workaround in Xen MMU's early bootup code (which is what these
>    two patches to this email have).
>  - or remove the patch introducing the regression altogether.
> 
> Foremost important is to fix the regression, and attached patches 
> achieve that. I want to remove this workaround patch when we
> hammer out more appropriate semantics for the page table creation - but
> that will take some time and the runway to do that in 2.6.39 is gone.
> 

My inclination would be to apply your workaround -- are there any
adverse effects to doing that?

	-hpa

[Sorry if I have missed any emails recently... apparently my email was
significantly on the fritz over the last few days.]
