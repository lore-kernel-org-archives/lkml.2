Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1CJTRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:17:37 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42662 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1CJTRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:17:36 -0500
Date: Thu, 10 Mar 2011 19:17:04 +0000
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
Message-ID: <20110310191704.GA24615@srcf.ucam.org>
References: <1299784370-18061-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299784370-18061-1-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 01:12:50PM -0600, Corey Minyard wrote:

> +	smi_info->last_timeout_jiffies ?iffies;

Something looks mangled here? Otherwise, ACK.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
