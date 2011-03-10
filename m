Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1CJUVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:21:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57059 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1CJUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:21:30 -0500
Date: Thu, 10 Mar 2011 20:21:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corey Minyard <minyard@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        YiCheng Doe <yicheng.doe@hp.com>,
        Tom Mingarelli <thomas.mingarelli@hp.com>,
        Andy Cress <andy.cress@us.kontron.com>,
        Mika Lansirine <Mika.Lansirinne@stonesoft.com>,
        Brian De Wolf <bldewolf@csupomona.edu>,
        Jean Michel Audet <Jean-Michel.Audet@ca.Kontron.com>,
        Jozef Sudelsky <jozef.sudolsky@elbiahosting.sk>,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] ipmi: Fix IPMI errors due to timing problems
Message-ID: <20110310202103.GA26268@srcf.ucam.org>
References: <1299787221-19542-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299787221-19542-1-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 02:00:21PM -0600, Corey Minyard wrote:
> From: Doe, YiCheng <yicheng.doe@hp.com>
> 
> This patch fixes an issue in OpenIPMI module where sometimes an ABORT command
> is sent after sending an IPMI request to BMC causing the IPMI request to fail.
> 
> Signed-off-by: YiCheng Doe <yicheng.doe@hp.com>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> Acked-by: Tom Mingarelli <thomas.mingarelli@hp.com>
> Tested-by: Andy Cress <andy.cress@us.kontron.com>
> Tested-by: Mika Lansirine <Mika.Lansirinne@stonesoft.com>
> Tested-by: Brian De Wolf <bldewolf@csupomona.edu>
> Cc: Jean Michel Audet <Jean-Michel.Audet@ca.Kontron.com>
> Cc: Jozef Sudelsky <jozef.sudolsky@elbiahosting.sk>
> Cc: Matthew Garrett <mjg@redhat.com>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
